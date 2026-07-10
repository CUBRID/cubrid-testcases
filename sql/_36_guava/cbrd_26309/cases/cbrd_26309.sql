/**
 * This test case verifies CBRD-26309: Estimate number of groups.
 *
 * Purpose:
 * GROUP BY optimizer cardinality should estimate the number of groups using
 * NDV (number of distinct values) of GROUP BY columns instead of treating
 * grouped and ungrouped queries the same way.
 *
 * Acceptance criteria:
 * AC1. Single-table, single-column GROUP BY estimates the actual NDV.
 * AC2. Multi-column GROUP BY may overestimate actual groups by multiplying NDVs,
 *    but the estimate must not exceed estimated row cardinality.
 * AC3. Filtered GROUP BY estimates fewer groups than the equivalent unfiltered
 *    query by using the filtered-row estimate.
 * AC4. JOIN GROUP BY applies the same group-count estimate after join and filter
 *    selectivity.
 * AC5. Expressions, DISTINCT, HAVING, LIMIT, constants, NULLs, and boundary row
 *    counts keep the group estimate inside the row cardinality cap.
 */

drop table if exists t1;

create table t1 (col1 varchar(10), col2 varchar(10), col3 int, col4 varchar(10));

insert into t1
  select mod(rownum,10), mod(rownum,100), mod(rownum,1000), rownum
  from db_class a, db_class b, db_class c, db_class d limit 10000;

create index idx on t1(col1,col2,col3);
create index idx3 on t1(col3);
create index idx4 on t1(col2);
create index idx2 on t1(col4);

update statistics on t1;

set optimization level 513;

evaluate 'Case 1. single table, single GROUP BY column, no filter : Ngroups must equal actual NDV (AC1)';
select /*+ recompile */ count(*) from (select 1 from t1 group by col1);
-- Expected result: 10 groups. Optimizer estimate target: NDV(col1) = 10.

select /*+ recompile */ count(*) from (select 1 from t1 group by col3);
-- Expected result: 1000 groups. Optimizer estimate target: NDV(col3) = 1000.

select /*+ recompile */ count(*) from (select 1 from t1 group by col4);
-- Expected result: 10000 groups. Optimizer estimate target: NDV(col4) = 10000.

evaluate 'Case 2. single table, multiple GROUP BY columns, no filter : Ngroups = product of NDVs, capped at cardinality (AC2)';
select /*+ recompile */ count(*) from (select 1 from t1 group by col1,col2);
-- Expected result: 100 actual groups because col1 is functionally dependent on col2.
-- Optimizer estimate target: NDV(col1) * NDV(col2), capped by estimated row cardinality.

select /*+ recompile */ count(*) from (select 1 from t1 group by col1,col2,col3);
-- Expected result: 1000 actual groups because col1 and col2 are functionally dependent on col3.
-- Optimizer estimate target: NDV product capped by estimated row cardinality.

select /*+ recompile */ count(*) from (select 1 from t1 group by col1,col1);
-- Expected result: 10 groups. Optimizer estimate target: duplicate GROUP BY column counted once.

evaluate 'Case 3. single table with filter : filtered Ngroups must be lower than unfiltered Ngroups (AC3)';
select /*+ recompile */ count(*) from (select 1 from t1 where col1 = 3 group by col3);
-- Expected result: 100 actual groups. Optimizer estimate target: lower than unfiltered col3 estimate 1000.

select /*+ recompile */ count(*) from (select 1 from t1 where col1 = 3 and col2 = 3 group by col3);
-- Expected result: 10 actual groups. Optimizer estimate target: further reduced by the additional col2 filter.

select /*+ recompile */ count(*) from (select 1 from t1 where col1 = 3 and col2 = 3 group by col3, col2);
-- Expected result: 10 actual groups. Optimizer estimate target: same as previous because col2 is fixed.

select /*+ recompile */ count(*) from (select 1 from t1 where col1 = 3 group by col3, col2);
-- Expected result: 100 actual groups. Optimizer estimate target: same filtered estimate as col3 alone.

evaluate 'Case 4. functions in GROUP BY : NDV is taken from the underlying column, not the function result';
select /*+ recompile */ count(*) from (select 1 from t1 where col1 = 3 group by nvl(col3,''), decode(col2,1,2,3,4,col2));
-- Expected result: 100 actual groups. Optimizer estimate target: expression arguments resolve to base column NDV.

evaluate 'Case 5. constants in GROUP BY : constant-only grouping and mixed column/constant grouping';
select /*+ recompile */ count(*) from (select 1 from t1 group by 1);
-- Expected result: 1 actual group. Optimizer estimate target: constant GROUP BY must stay inside row-cardinality cap.

select /*+ recompile */ count(*) from (select 1 from t1 group by nvl(col3,0), 1);
-- Expected result: 1000 groups. Optimizer estimate target: only nvl(col3,0) contributes NDV.

evaluate 'Case 6. HAVING clause : filters after grouping, does not affect the estimated Ngroups itself';
select /*+ recompile */ count(*) from (select col3 from t1 group by col3 having count(*) > 5);
-- Expected result: 1000 groups. Optimizer estimate target: same Ngroups estimate as GROUP BY col3 without HAVING.

evaluate 'Case 7. LIMIT combined with GROUP BY : LIMIT caps the estimated Ngroups (AC5, cannot exceed row estimate)';
select /*+ recompile */ count(*) from (select 1 from t1 group by col1 limit 3);
-- Expected result: 3 groups. Optimizer estimate target: LIMIT caps the group estimate below NDV(col1) = 10.

evaluate 'Case 8. DISTINCT interactions : DISTINCT alone follows the same NDV rule as GROUP BY';
select /*+ recompile */ * from (select distinct col1 from t1);
-- Expected result: 10 rows, values 0 through 9. Optimizer estimate target: NDV(col1) = 10.

select /*+ recompile */ count(*) from (select distinct col1,col2 from t1);
-- Expected result: 100 actual pairs because col1 is functionally dependent on col2.
-- Optimizer estimate target: NDV(col1) * NDV(col2), capped by estimated row cardinality.

select /*+ recompile */ count(*) from (select distinct col1,col2 from t1 group by col1);
-- Expected result: 10 groups. Optimizer estimate target: GROUP BY col1 dominates.

evaluate 'Case 9. CTE / view : GROUP BY estimate propagates through the derived table / CTE boundary';
with cte as (select /*+ recompile */ col1,col2 from t1 where col1 = 1 group by col1,col2)
select * from cte;
-- Expected result: 10 rows, col1 = 1 with col2 values 1,11,...,91.
-- Optimizer estimate target: CTE scan uses the filtered GROUP BY estimate.

evaluate 'Case 10. Nested subquery : GROUP BY estimate of an inner derived table is not recomputed by the outer query';
select /*+ recompile */ count(*) from (
  select col1
  from (
    select * from t1 group by col1, col2
  ) x
  group by col1
);
-- Expected result: 10 actual groups. Optimizer estimate target: inner derived table estimate is carried through.

evaluate 'Case 11. JOIN, single GROUP BY column : same NDV formula applied to joined result (N/p from join+filter estimates) (AC4)';
with cte as (select /*+ recompile */ count(*) from t1 a, t1 b where a.col4 = b.col4 group by a.col1)
select /*+ recompile */ count(*) from cte;
-- Expected result: 10 groups. Optimizer estimate target: NDV(a.col1) over joined result.

evaluate 'Case 12. JOIN with filter, multiple GROUP BY columns : Ngroups reduced by filter formula relative to unfiltered join case (AC4)';
with cte as (select /*+ recompile */ count(*) from t1 a, t1 b where a.col4 = b.col4 and a.col2 = 3 group by a.col1, a.col3)
select /*+ recompile */ count(*) from cte;
-- Expected result: 10 actual groups. Optimizer estimate target: filter reduces joined GROUP BY estimate.

evaluate 'Case 13. Multi-way JOIN with filter : formula still applies, group count capped below full NDV product (AC2, AC4)';
with cte as (select /*+ recompile */ count(*) from t1 a, t1 b, t1 c
             where a.col4 = b.col4 and a.col3 = c.col3 and a.col2 = 3
             group by a.col1, a.col3, c.col2)
select /*+ recompile */ count(*) from cte;
-- Expected result: 10 actual groups. Optimizer estimate target: multi-way join GROUP BY remains capped.

evaluate 'Case 14. View join : each side''s GROUP BY estimate feeds correctly into the outer join cardinality (AC2, AC4 cap still holds)';
select /*+ recompile */ count(*)
from (select a.* from t1 a, t1 b where a.col4 = b.col4 and a.col1 = 3 group by a.col4) aa,
     (select a.* from t1 a, t1 b where a.col4 = b.col4 group by a.col1) bb
where aa.col4 = bb.col4;
-- Expected result: 1 actual joined row. Optimizer estimate target: each derived table keeps its GROUP BY estimate.

evaluate 'Case 15. UNION : each branch''s GROUP BY estimate is computed independently';
select /*+ recompile */ count(*) cnt from (select 1 from t1 group by col1)
union
select /*+ recompile */ count(*) cnt from (select 1 from t1 group by col4);
-- Expected result: two rows, 10 and 10000. Optimizer estimate target: branch estimates computed independently.

evaluate 'Case 16. Function-based index statistics are used for expression GROUP BY';
drop table if exists t2;
create table t2 (c1 int);
create index i1 on t2 (c1);
insert into t2
  select rownum
  from db_class a, db_class b, db_class c, db_class d
  limit 2000;
update statistics on t2;

select /*+ recompile */ count(*) from (select 1 from t2 group by c1);
-- Expected result: 2000 groups. Optimizer estimate target: NDV(c1) = 2000.

select /*+ recompile */ count(*) from (select 1 from t2 group by mod(c1, 2));
-- Expected result: 2 actual groups. Optimizer estimate target before function-index stats: estimate uses underlying c1 NDV.

create index i2 on t2 (mod(c1, 2));
update statistics on t2;

select /*+ recompile */ count(*) from (select 1 from t2 group by mod(c1, 2));
-- Expected result: 2 actual groups. Optimizer estimate target after function-index stats: estimate uses mod(c1,2) NDV.

drop table t2;

evaluate 'Case 17. filter matches zero rows (p = 0) : Ngroups must degrade to 0, not error or fall back to full NDV';
select /*+ recompile */ count(*) from t1 where col1 = 'no_such_value';
-- Expected result: 0 rows.

select /*+ recompile */ count(*) from (select 1 from t1 where col1 = 'no_such_value' group by col3);
-- Expected result: 0 groups. Optimizer estimate target: p = 0 must not fall back to full NDV.

evaluate 'Case 18. filter matches all rows (p = N) : Ngroups must equal the unfiltered NDV case (formula boundary)';
select /*+ recompile */ count(*) from (select 1 from t1 where col1 in ('0','1','2','3','4','5','6','7','8','9') group by col3);
-- Expected result: 1000 groups. Optimizer estimate target: same as unfiltered GROUP BY col3.

evaluate 'Case 19. empty table (N = 0) : Ngroups estimate must not divide by zero or error out';
drop table if exists t_empty;
create table t_empty (c1 int);
create index t_empty_i on t_empty(c1);
update statistics on t_empty;

select /*+ recompile */ count(*) from (select 1 from t_empty group by c1);
-- Expected result: 0 groups, query compiles and executes without error.

drop table t_empty;

evaluate 'Case 20. single-row table (N = 1) : Ngroups estimate degenerates cleanly to 1';
drop table if exists t_single;
create table t_single (c1 int);
insert into t_single values (1);
update statistics on t_single;

select /*+ recompile */ count(*) from (select 1 from t_single group by c1);
-- Expected result: 1 group.

drop table t_single;

evaluate 'Case 21. GROUP BY column containing NULLs : NULL must be counted as exactly one additional group, not excluded or duplicated';
drop table if exists t_null;
create table t_null (c1 int);
insert into t_null
  select case when mod(rownum,10) = 0 then null else mod(rownum,9) end
  from db_class a, db_class b limit 1000;
update statistics on t_null;

select /*+ recompile */ count(*) from (select 1 from t_null group by c1);
-- Expected result: 10 groups, nine non-null groups plus one NULL group.

drop table t_null;

evaluate 'Case 22. range/inequality filter (non-equality predicate) : formula must still apply using the range''s estimated selectivity as p';
select /*+ recompile */ count(*) from (select 1 from t1 where col3 < 500 group by col3);
-- Expected result: 500 actual groups. Optimizer estimate target: lower than unfiltered col3 estimate 1000.

drop table t1;
