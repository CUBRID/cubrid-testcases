/*
 * This test case verifies CBRD-27158 : set operations (UNION/INTERSECT/EXCEPT)
 * corrupt rows produced by a GROUP BY query combined with a window function.
 *
 * Bug: when a query mixing GROUP BY aggregates and a window function (OVER
 * clause) participates in a set operation, CUBRID rewrites it internally as
 * a derived table (mq_rewrite_aggregate_as_derived) so the window function
 * can be evaluated on top of the grouped result. The hidden column names
 * generated for that derived table were not guaranteed unique, so when
 * multiple such rewrites occurred (multiple window functions in one branch,
 * or multiple branches of a set operation), the hidden columns could
 * collide -- corrupting which value ends up in which output column/row.
 *
 * Fix: mq_rewrite_aggregate_as_derived now generates unique hidden column
 * names for every rewrite.
 *
 * Note: the existing CBRD-27158 coverage merged via PR #3190 (develop) and
 * backported via PR #3296 (release/11.4) only exercises CUBRIDs own
 * pseudocolumns (rownum / orderby_num() / groupby_num() / inst_num())
 * combined with GROUP BY and set operators. It does not exercise a genuine
 * ANSI window function (OVER clause), which is what this test case adds.
 *
 * Note: table/column names use letters (ta/tb), not digits, because CTP
 * masks digits in the trace output to ?, same convention as
 * CBRD-26571 cbrd_26571.sql and CBRD-26522s cbrd_26522.sql.
 *
 * Note: Cases 1, 2, 3, 4, 5 add an explicit trailing ORDER BY over the whole
 * set-operation result (by ordinal position). Without it the row order
 * across UNION/UNION ALL branches is not guaranteed -- the trace shows the
 * UNION node can use parallel workers, same non-determinism risk seen in
 * CBRD-26522 cbrd_26522.sql -- so a byte-for-byte answer comparison could
 * fail even when every value is correct.
 *
 * Coverage:
 *   Case 1: GROUP BY + a window function in two UNION ALL branches
 *           -> result values must be correct and the trace rewritten
 *              query must show unique hidden column names per branch
 *   Case 2: two window functions in the SAME branch (row_number(), rank())
 *           -> each window function hidden column must get its own unique
 *              name, not collide with the other one in the same branch.
 *              grp is added as a tiebreak inside each OVER clause because
 *              tb has two groups with an equal sum(val) (g1 and g2, both
 *              300) -- without a tiebreak, row_number() over such a tie is
 *              not deterministic by SQL semantics, regardless of this fix
 *   Case 3: the same GROUP BY + window pattern combined via INTERSECT
 *           -> the fix must also cover INTERSECT, not only UNION. The
 *              second branch excludes grp g3 so the two branches actually
 *              differ -- intersecting a branch with an identical copy of
 *              itself would match even if both sides were corrupted the
 *              same way, proving nothing
 *   Case 4: the same GROUP BY + window pattern combined via EXCEPT
 *           -> the fix must also cover EXCEPT, not only UNION. Mirrors
 *              Case 3: the second branch is ta itself with grp g3 excluded,
 *              so EXCEPT has a real, known row (g3) to remove -- the
 *              original ta-vs-tb branches shared no matching rows at all,
 *              so nothing was ever actually being subtracted
 *   Case 5: 3-way UNION ALL, GROUP BY + window function in every branch
 *           -> hidden column uniqueness must hold across 3+ branches, not
 *              just the first two
 *   Case 6: ORDER BY applied to the whole set-operation result, referencing
 *           the window-function column by its exposed alias
 *           -> if hidden columns collided internally, ORDER BY could bind to
 *              the wrong column and silently produce the wrong row order.
 *              this is the most direct way "corrupted rows" would surface
 *   Case 7: the original CBRD-27158 report repro (table td here), standalone
 *           -- a branch-level trailing ORDER BY on the grouped column itself,
 *           not just the window functions own OVER clause, with no set
 *           operation at all yet
 *           -> baseline: this is a different hidden-column source than
 *              Cases 1-6 (the branch ORDER BY needs its own hidden column,
 *              separate from the ones the window function rewrite creates),
 *              and must produce correct values on its own before Case 8
 *              adds a set operation around it
 *   Case 8: the same query as Case 7, now combined via UNION with a second,
 *           always-empty branch (tables td/te) -- the exact shape the bug
 *           was originally reported against
 *           -> must produce the same values as Case 7s standalone result,
 *              since the second branch never contributes any rows
 */

drop table if exists ta, tb;
create table ta (id int primary key, grp varchar(10), val int);
create table tb (id int primary key, grp varchar(10), val int);

insert into ta values (1,'g1',10), (2,'g1',20), (3,'g2',30), (4,'g2',40), (5,'g3',50);
insert into tb values (1,'g1',100), (2,'g1',200), (3,'g2',300);
commit;

set trace on;

evaluate 'Case 1: GROUP BY + window function in two UNION ALL branches -> correct values and unique hidden column names';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
union all
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from tb group by grp
order by 1, 2, 3;
show trace;


evaluate 'Case 2: two window functions in the same branch (row_number, rank) -> each must get its own unique hidden column';
select /*+ recompile */ grp, sum(val) as s, row_number() over (order by sum(val), grp) as rn, rank() over (order by sum(val) desc, grp) as rk from ta group by grp
union all
select grp, sum(val) as s, row_number() over (order by sum(val), grp) as rn, rank() over (order by sum(val) desc, grp) as rk from tb group by grp
order by 1, 2, 3, 4;
show trace;


evaluate 'Case 3: GROUP BY + window function combined via INTERSECT -> the fix must cover INTERSECT too';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
intersect
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta where grp <> 'g3' group by grp
order by 1, 2, 3;
show trace;


evaluate 'Case 4: GROUP BY + window function combined via EXCEPT -> the fix must cover EXCEPT too';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
except
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta where grp <> 'g3' group by grp
order by 1, 2, 3;
show trace;


evaluate 'Case 5: 3-way UNION ALL, GROUP BY + window function in every branch -> hidden column uniqueness must hold across 3+ branches';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
union all
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from tb group by grp
union all
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta where val > 20 group by grp
order by 1, 2, 3;
show trace;


evaluate 'Case 6: ORDER BY on the whole set-operation result must bind to the correct (renamed) window-function column';
select * from (
  select /*+ recompile */ grp, sum(val) as s, sum(sum(val)) over (order by grp) as running_total from ta group by grp
  union all
  select grp, sum(val) as s, sum(sum(val)) over (order by grp) as running_total from tb group by grp
) x order by running_total desc;
show trace;


drop table if exists te, td;
create table td (id int, ts datetime);
create table te (val int);

insert into td values (1, '2026-01-01 00:00:00');

evaluate 'Case 7: original report repro, standalone - branch-level ORDER BY on the grouped column, no set operation yet';
select /*+ recompile */ count(ts) as out_a, dense_rank() over (order by id asc) as out_b, count(id) as out_c
from td
group by id
order by id;
show trace;


evaluate 'Case 8: Case 7 combined via UNION with an always-empty second branch';
(select /*+ recompile */ count(ts) as out_a, dense_rank() over (order by id asc) as out_b, count(id) as out_c
from td group by id order by id)
union
select val as out_a, val as out_b, val as out_c from te where val < 0;
show trace;

drop table if exists te, td;


drop table if exists ta, tb;
