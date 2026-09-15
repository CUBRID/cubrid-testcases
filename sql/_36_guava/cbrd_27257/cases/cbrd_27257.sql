/*
 * This test case verifies CBRD-27257 : LEFT/RIGHT OUTER JOIN drops its
 * NULL-padding rows and silently degrades to INNER JOIN behavior when the
 * ON-clause OR condition is large enough.
 *
 * Bug: pt_transform_cnf_post() rebalances a large OR tree via the
 * TRANSFORM_CNF_OR_COMPACT path once count_and_or() (OR = left*right,
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
 * Cases 10-13 (bagus-kim, issue comment) and 14-15 (ssihil, issue comment)
 * extend coverage beyond the fix PRs own case table:
 *   Case 10: a large ON-clause OR on the SECOND of two chained LEFT OUTER
 *           JOINs (join level 2, not 1)
 *           -> the fix copies location from the original node rather than
 *              leaving it at its default with only one join in Cases 1-9
 *              that default (0) and a correctly-copied level-1 join both
 *              read as location 0, so they cannot tell the copy apart from
 *              the default -- a second join makes the correct value (2)
 *              and the default (0) diverge
 *   Case 11: the Case 2 condition with extra q rows added so the 2nd and
 *           3rd OR disjuncts are each the one that actually decides a row,
 *           not just the 1st -- isolates whether the OR node the fix
 *           rebuilds keeps every disjunct live, not only the first one
 *           checked
 *           -> the rows it adds to p/q are removed immediately after, so
 *              every later case still sees the original 3-row p / 1-row q
 *   Case 12: an ON-clause OR sized to exactly 101 (5x5x4 leaves, plus 1 for
 *           the p.id=q.id join predicate the OR is ANDed with) -- the
 *           smallest size that crosses the >100 switch
 *           -> Case 1 (64) is the largest already-covered size at or below
 *              the threshold and Case 2 (125) the smallest already-covered
 *              size above it, leaving 101-124 unexercised this pins down
 *              the exact boundary instead of a size comfortably past it
 *   Case 13: the Case 2 condition with a primary key on the inner side, so
 *           the plan is an index join instead of a table scan
 *           -> qo_analyze_term() places terms differently depending on
 *              whether the inner side is indexed, and the fix PRs own fuzz
 *              oracle (see the note below) was PK-join based, so an
 *              indexed inner side was never exercised by Cases 1-9
 *   Case 14: the Case 2 OR with one disjunct rewritten to reference only
 *           the outer (p) side, so it can turn true on its own for a
 *           padding row without any inner (q) column being non-NULL
 *           -> Cases 1-9 either lose every padding row uniformly or none
 *              at all, because every disjunct depends on the (NULL-valued,
 *              on a padding row) inner columns an outer-only disjunct can
 *              make one specific padding row survive by coincidence while
 *              others are still wrongly dropped, so this catches a partial
 *              (mixed pass/fail) misclassification that a uniform-loss
 *              case cannot
 *   Case 15: real matches and both kinds of padding (a q row exists but no
 *           OR disjunct matches it, and no q row exists at all) side by
 *           side in one result, on dedicated tables p2/q2
 *           -> Cases 1-9 only ever show a single real match plus padding
 *              rows of one uniform kind this checks the fix does not
 *              disturb genuine matches while still restoring both padding
 *              kinds in the same query
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


evaluate 'Case 4b (C4): the Case 4 condition again as a row list -- the unmatched p rows must come back with q columns NULL, not merely be counted';
select p.id, q.id from q right outer join p
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3))
order by 1;


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
   or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3)
order by 1;


evaluate 'Case 8 (C8): the same large OR as a single-table WHERE filter, no join at all -- control, unaffected by the fix';
select id from q
where (v1=1 and v2=1 and v3=1 and v4=1 and v5=1)
   or (v1=2 and v2=2 and v3=2 and v4=2 and v5=2)
   or (v1=3 and v2=3 and v3=3 and v4=3 and v5=3)
order by id;


evaluate 'Case 9 (C9): the Case 2 condition, OUTER JOIN target wrapped as an inline view instead of a plain table';
select p.id, iv.id from p left outer join
  (select id, v1, v2, v3, v4, v5 from q group by id, v1, v2, v3, v4, v5) iv
  on p.id=iv.id and ((iv.v1=1 and iv.v2=1 and iv.v3=1 and iv.v4=1 and iv.v5=1)
                 or (iv.v1=2 and iv.v2=2 and iv.v3=2 and iv.v4=2 and iv.v5=2)
                 or (iv.v1=3 and iv.v2=3 and iv.v3=3 and iv.v4=3 and iv.v5=3))
order by 1;


drop table if exists r;
create table r (id int, w1 int, w2 int, w3 int, w4 int, w5 int);
insert into r values (1,1,1,1,1,1);
commit;

evaluate 'Case 10 : large ON-clause OR on the SECOND of two chained LEFT OUTER JOINs -- the join level number must be copied from the original node, not fixed at 1';
select p.id, q.id, r.id
  from p left outer join q on p.id = q.id
         left outer join r on p.id = r.id
           and ((r.w1=1 and r.w2=1 and r.w3=1 and r.w4=1 and r.w5=1)
             or (r.w1=2 and r.w2=2 and r.w3=2 and r.w4=2 and r.w5=2)
             or (r.w1=3 and r.w2=3 and r.w3=3 and r.w4=3 and r.w5=3))
order by 1;


evaluate 'Case 11 : above-threshold ON-clause OR where the 2nd and 3rd disjuncts are the deciding arm, not just the 1st';
insert into p values (4);
insert into q values (2,2,2,2,2,2), (3,3,3,3,3,3), (4,4,4,4,4,4);
commit;
select p.id, q.id from p left outer join q
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3))
order by 1, 2;

delete from q where id in (2, 3, 4);
delete from p where id = 4;
commit;


evaluate 'Case 12 : ON-clause OR sized to 101 (5x5x4 leaves plus the join predicate) -- the smallest size that crosses the >100 switch';
select p.id, q.id from p left outer join q
  on p.id=q.id and ((q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
                 or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
                 or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3))
order by 1;


evaluate 'Case 13 : the Case 2 condition with a primary key on the inner side, so the plan is an index join instead of a table scan';
drop table if exists qk;
create table qk (id int primary key, v1 int, v2 int, v3 int, v4 int, v5 int);
insert into qk values (1,1,1,1,1,1);
commit;
select p.id, qk.id from p left outer join qk
  on p.id=qk.id and ((qk.v1=1 and qk.v2=1 and qk.v3=1 and qk.v4=1 and qk.v5=1)
                  or (qk.v1=2 and qk.v2=2 and qk.v3=2 and qk.v4=2 and qk.v5=2)
                  or (qk.v1=3 and qk.v2=3 and qk.v3=3 and qk.v4=3 and qk.v5=3))
order by 1;


evaluate 'Case 14 : mixing an outer-only OR disjunct with inner-only disjuncts -- detects partial padding loss, not just total loss';
select p.id, q.id from p left outer join q
  on p.id=q.id and (
       (p.id=3)
    or (q.v1=1 and q.v2=1 and q.v3=1 and q.v4=1 and q.v5=1)
    or (q.v1=2 and q.v2=2 and q.v3=2 and q.v4=2 and q.v5=2)
    or (q.v1=3 and q.v2=3 and q.v3=3 and q.v4=3 and q.v5=3))
order by 1;


evaluate 'Case 15 : matched rows and both kinds of padding (OR-mismatch, no partner row) coexisting in one result';
drop table if exists q2, p2;
create table p2 (id int);
create table q2 (id int, v1 int, v2 int, v3 int, v4 int, v5 int);

insert into p2 values (1), (2), (3), (4);
insert into q2 values (1,1,1,1,1,1),
                      (2,2,2,2,2,2),
                      (3,9,9,9,9,9);
commit;

select p2.id, q2.id from p2 left outer join q2
  on p2.id=q2.id and ((q2.v1=1 and q2.v2=1 and q2.v3=1 and q2.v4=1 and q2.v5=1)
                  or (q2.v1=2 and q2.v2=2 and q2.v3=2 and q2.v4=2 and q2.v5=2)
                  or (q2.v1=3 and q2.v2=3 and q2.v3=3 and q2.v4=3 and q2.v5=3))
order by 1;


drop table if exists q2, p2, qk, r, q, p;
