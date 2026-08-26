/*
 * This test case verifies CBRD-27257 : LEFT/RIGHT OUTER JOIN drops its
 * NULL-padding rows and silently degrades to INNER JOIN behavior when the
 * ON-clause OR condition is large enough.
 *
 * Bug: pt_transform_cnf_post() rebalances a large OR tree via the
 * TRANSFORM_CNF_OR_COMPACT path once count_and_or() (OR = left+right,
 * AND = left+right, leaf = 1) exceeds 100. The pt_and() call it uses to
 * build the new OR node only sets op/arg1/arg2, leaving the new nodes
 * info.expr.location at its default (0) instead of copying the original
 * nodes location. qo_analyze_term() then classifies that ON-clause filter
 * as a WHERE-level term (after join term, location 0) instead of a
 * join-level term, so it gets applied after the outer join has already
 * produced its NULL-padded rows -- and, like an ordinary WHERE filter
 * referencing the inner sides columns, it discards every row whose inner
 * side is NULL. The net effect is that unmatched outer rows disappear,
 * making the OUTER JOIN behave like an INNER JOIN. At or below the 100
 * threshold, OR terms are combined through the or_next distribution path
 * instead, which does propagate location correctly, so the bug is strictly
 * a function of OR-tree size, not of anything semantically different about
 * the condition.
 *
 * Fix: the OR node built in the TRANSFORM_CNF_OR_COMPACT path now also
 * copies location from the original node (and sets op/type_enum), so
 * qo_analyze_term() classifies it as a join-level term again regardless of
 * OR-tree size.
 *
 * Coverage: numbered C1-C9 to match the case table in the fix PRs (develop
 * CUBRID/cubrid#7729, release/11.4 backport CUBRID/cubrid#7755) Remarks
 * section, so each case here can be cross-referenced against the reported
 * before/after row counts directly.
 *   Case 1 (C1): LEFT OUTER, ON-clause OR at 3 branches x 4 leaves each
 *           (count_and_or = 64, at or below the 100 threshold)
 *           -> control: below the threshold, NULL padding must already
 *              survive even without the fix -- confirms the break point is
 *              the OR-tree size, not the query shape itself
 *   Case 2 (C2): same shape, but 3 branches x 5 leaves each (count_and_or =
 *           125, above the threshold) -- the reports primary repro
 *           -> NULL padding for the two unmatched p rows must survive
 *   Case 3 (C3): 4 branches x 4 leaves each (count_and_or = 256, further
 *           above the threshold)
 *           -> same expected padding as Case 2, at a different OR-tree size
 *              to confirm the fix does not only cover the exact 125 case
 *   Case 4 (C4): the Case 2 condition run as a RIGHT OUTER JOIN, using
 *           COUNT(*) as the report specified
 *           -> the fix must cover RIGHT OUTER JOIN too, not only LEFT
 *   Case 5 (C5): LEFT OUTER, an above-threshold OR whose disjuncts do not
 *           match qs one row at all (unlike Cases 2/3, where p.id = 1
 *           does match)
 *           -> every p row must come back NULL-padded (3 rows all NULL) -
 *              before the fix this case returns 0 rows, since the
 *              mis-classified filter also discards the one real
 *              (non-matching) row along with all the synthetic padding --
 *              a stronger symptom than Cases 2/3, where the one real match
 *              survives and only the padding disappears
 *   Case 6 (C6): the Case 2 condition run as an INNER JOIN instead
 *           -> control: INNER JOIN has no padding rows to lose in the
 *              first place, so this must return the same single matching
 *              row both before and after the fix -- isolates the bug to
 *              outer joins specifically, not to evaluating a large OR
 *   Case 7 (C7): the same large OR written as a genuine WHERE-clause filter
 *           after a plain (unconditional) LEFT OUTER JOIN, instead of in
 *           the ON clause
 *           -> control: a real WHERE-level filter was never misclassified
 *              by this bug, so it must return only the one matching row
 *              (1,1) both before and after the fix -- confirms the bug is
 *              specific to a large OR being written inside an ON clause
 *   Case 8 (C8): the same large OR as a single-table WHERE filter, no join
 *           at all
 *           -> control: isolates that evaluating a large OR by itself is
 *              not what breaks -- only its misclassification as a join
 *              term is
 *   Case 9 (C9): the Case 2 condition run with the joins inner side
 *           wrapped as an inline view instead of a plain table reference
 *           -> the fix must also apply when the OUTER JOINs target is a
 *              derived table, not only a base table
 *
 * Note: three/four-branch OR conditions in Cases 1/2/3/5/9 must each
 * compare against a genuinely different set of literals -- reusing the
 * same literals across disjuncts lets the optimizer fold them through a
 * common-filter-extraction path that does not exercise this bug.
 *
 * Note: the fix PRs also ran a 600-query differential fuzz sweep (random
 * predicates, oracle: a LEFT OUTER JOIN b ON a.id=b.id AND (P) must return
 * COUNT(*) = the row count of a regardless of P, since b.id is a primary
 * key) to confirm no regression across ON/WHERE/INNER placements at both
 * OR sizes. That sweep is a development-time verification tool, not
 * reproduced here -- Cases 1-9 are the named, deterministic subset of it
 * that pins down the exact reported behavior.
 */

drop table if exists q, p;
create table p (id int);
create table q (id int, v1 int, v2 int, v3 int, v4 int, v5 int);

insert into p values (1), (2), (3);
insert into q values (1,1,1,1,1,1);
commit;


evaluate 'Case 1 (C1): LEFT OUTER, ON OR at the 64-node size (<=100 threshold) -- padding must survive regardless of the fix';
select p.id, q.id from p left outer join q
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3))
order by 1;


evaluate 'Case 2 (C2): LEFT OUTER, ON OR at the 125-node size (>100 threshold) -- the reports primary repro, padding must survive after the fix';
select p.id, q.id from p left outer join q
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3))
order by 1;


evaluate 'Case 3 (C3): LEFT OUTER, ON OR at the 256-node size (4 branches x 4 leaves) -- same padding expected at a different OR-tree size';
select p.id, q.id from p left outer join q
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3)
                 or (q.v1=4 and q.v2=4 and q.v3=4 and q.v4=4))
order by 1;


evaluate 'Case 4 (C4): the Case 2 condition as RIGHT OUTER JOIN, checked via COUNT(*) as the report specified';
select count(*) from q right outer join p
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3));


evaluate 'Case 5 (C5): LEFT OUTER, >100 OR with no disjunct matching qs row at all -- every p row must come back NULL-padded';
select p.id, q.id from p left outer join q
  on p.id=q.id and ((q.v1=7 and q.v2=7 and q.v3=7 and q.v4=7 and q.v5=7)
                 or (q.v1=8 and q.v2=8 and q.v3=8 and q.v4=8 and q.v5=8)
                 or (q.v1=9 and q.v2=9 and q.v3=9 and q.v4=9 and q.v5=9))
order by 1;


evaluate 'Case 6 (C6): the Case 2 condition as INNER JOIN -- control, must return only the one real match either way';
select p.id, q.id from p inner join q
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3))
order by 1;


evaluate 'Case 7 (C7): the same large OR as a genuine WHERE-level filter after a plain LEFT OUTER JOIN -- control, unaffected by the fix';
select p.id, q.id from p left outer join q on p.id=q.id
where (q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
   or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
   or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3);


evaluate 'Case 8 (C8): the same large OR as a single-table WHERE filter, no join at all -- control, unaffected by the fix';
select id from q
where (v1=1 and v2=1 and v3=1 and v4=1 and v5=1)
   or (v1=2 and v2=2 and v3=2 and v4=2 and v5=2)
   or (v1=3 and v2=3 and v3=3 and v4=3 and v5=3);


evaluate 'Case 9 (C9): the Case 2 condition, OUTER JOIN target wrapped as an inline view instead of a plain table';
select p.id, iv.id from p left outer join (select * from q) iv
  on p.id=iv.id and ((iv.v1=1 and iv.v2=1 and iv.v3=1 and iv.v4=1 and iv.v5=1)
                 or (iv.v1=2 and iv.v2=2 and iv.v3=2 and iv.v4=2 and iv.v5=2)
                 or (iv.v1=3 and iv.v2=3 and iv.v3=3 and iv.v4=3 and iv.v5=3))
order by 1;


drop table if exists q, p;
