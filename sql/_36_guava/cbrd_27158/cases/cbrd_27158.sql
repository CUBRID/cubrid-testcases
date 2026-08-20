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
 * backported via PR #3296 (release/11.4) only exercises CUBRID's own
 * pseudocolumns (rownum / orderby_num() / groupby_num() / inst_num())
 * combined with GROUP BY and set operators. It does not exercise a genuine
 * ANSI window function (OVER clause), which is what this test case adds.
 *
 * Note: table/column names use letters (ta/tb), not digits, because CTP
 * masks digits in the trace output to ?, same convention as
 * CBRD-26571 cbrd_26571.sql and CBRD-26522s cbrd_26522.sql.
 *
 * Coverage:
 *   Case 1: GROUP BY + a window function in two UNION ALL branches
 *           -> result values must be correct and the trace's rewritten
 *              query must show unique hidden column names per branch
 *   Case 2: two window functions in the SAME branch (row_number(), rank())
 *           -> each window function hidden column must get its own
 *              unique name, not collide with the other one in the same branch
 *   Case 3: the same GROUP BY + window pattern combined via INTERSECT
 *           -> the fix must also cover INTERSECT, not only UNION
 *   Case 4: the same GROUP BY + window pattern combined via EXCEPT
 *           -> the fix must also cover EXCEPT, not only UNION
 *   Case 5: 3-way UNION ALL, GROUP BY + window function in every branch
 *           -> hidden column uniqueness must hold across 3+ branches, not
 *              just the first two
 *   Case 6: ORDER BY applied to the whole set-operation result, referencing
 *           the window-function column by its exposed alias
 *           -> if hidden columns collided internally, ORDER BY could bind to
 *              the wrong column and silently produce the wrong row order.
 *              this is the most direct way "corrupted rows" would surface
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
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from tb group by grp;
show trace;


evaluate 'Case 2: two window functions in the same branch (row_number, rank) -> each must get its own unique hidden column';
select /*+ recompile */ grp, sum(val) as s, row_number() over (order by sum(val)) as rn, rank() over (order by sum(val) desc) as rk from ta group by grp
union all
select grp, sum(val) as s, row_number() over (order by sum(val)) as rn, rank() over (order by sum(val) desc) as rk from tb group by grp;
show trace;


evaluate 'Case 3: GROUP BY + window function combined via INTERSECT -> the fix must cover INTERSECT too';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
intersect
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp;
show trace;


evaluate 'Case 4: GROUP BY + window function combined via EXCEPT -> the fix must cover EXCEPT too';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
except
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from tb group by grp;
show trace;


evaluate 'Case 5: 3-way UNION ALL, GROUP BY + window function in every branch -> hidden column uniqueness must hold across 3+ branches';
select /*+ recompile */ grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta group by grp
union all
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from tb group by grp
union all
select grp, sum(val), sum(sum(val)) over (order by grp) as running_total from ta where val > 20 group by grp;
show trace;


evaluate 'Case 6: ORDER BY on the whole set-operation result must bind to the correct (renamed) window-function column';
select * from (
  select /*+ recompile */ grp, sum(val) as s, sum(sum(val)) over (order by grp) as running_total from ta group by grp
  union all
  select grp, sum(val) as s, sum(sum(val)) over (order by grp) as running_total from tb group by grp
) x order by running_total desc;
show trace;

drop table if exists ta, tb;
