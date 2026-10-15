/**
 *  This test case verifies CBRD-27469 : generate a full index scan candidate in the
 *  PARTITION BY + ORDER BY order of an analytic function, so that an analytic query
 *  without a key-range condition can skip the analytic sort (CBRD-26473).
 *
 *  Before CBRD-27469 the analytic sort was skipped only when a WHERE range condition
 *  happened to make the optimizer pick the index; with no condition the query ran as
 *  TABLE SCAN + analytic sort. Now the optimizer also generates an index scan whose
 *  key order covers the analytic sort list and weighs it against TABLE SCAN + sort.
 *
 *  Plan cases are checked from "show trace" (INDEX SCAN / TABLE SCAN and the
 *  "ANALYTIC #N (... sort: true|false ...)" line). Each plan case is followed by a
 *  value case that compares the result of the index path with the same query forced
 *  onto a sequential scan (using index none), so the result does not depend on the
 *  scan order of the rows.
 *
 *  1. No condition - PARTITION BY + ORDER BY, PARTITION BY only, ORDER BY only (PK index)
 *  2. USING INDEX hint without a key-range condition is honored
 *  3. Several analytic functions - the index-ordered one runs first and skips its sort,
 *     functions on index-prefix keys share one sort group, and sort keys that are also
 *     in the select list (written as positions after semantic check)
 *  4. ORDER BY of the query is still sorted after the analytic evaluation
 *  5. Nullable partition column - a multi-column index whose other key column is NOT NULL
 *     holds the NULL partition and is used; a single-column index does not hold the
 *     NULL keys and is not used. The NULL keys form one partition and tie in the ORDER BY
 *     key as they do after a sort (the sort-skip path compared them as unknown and
 *     started a new partition at every NULL row before CBRD-27469)
 *  6. Cases that keep TABLE SCAN - non-covering index on a large table (index lookup costs
 *     more than the sort it saves), DESC order on an ASC index, GROUP BY, join,
 *     partitioned table
 *  7. NULL partition key on the key-range sort-skip path of CBRD-26473 (wrong result before
 *     CBRD-27469: every NULL row started a new partition)
 */

drop table if exists t27469;
create table t27469 (col1 int primary key, col2 char(1), col3 int, col4 char(1), col5 char(1), col6 int);

insert into t27469
with recursive cte (k) as (
  select 1
  union all
  select k + 1 from cte where k < 1000
)
select n, chr(65 + mod(n, 26)), n + 99999, chr(65 + mod(n, 26)), chr(65 + mod(n, 3)), mod(n, 3) + 1
from (select (b.k - 1) * 1000 + a.k as n from cte a, cte b where b.k <= 50) t;

create index idx_col2_col1_col3 on t27469 (col2, col1, col3);
update statistics on t27469 with fullscan;

set trace on;

--
-- 1. No condition
--
evaluate '1-1. PARTITION BY + ORDER BY, no condition - INDEX SCAN, sort skipped';
select /*+ recompile */ count(*), sum(d) from (
  select dense_rank() over (partition by col2 order by col1) d from t27469) x;
show trace;

evaluate '1-1v. same value as the sequential scan';
select count(*) from (
  select col1, dense_rank() over (partition by col2 order by col1) d from t27469) a,
  (select col1, dense_rank() over (partition by col2 order by col1) d from t27469 using index none) b
where a.col1 = b.col1 and a.d = b.d;

evaluate '1-2. PARTITION BY only - INDEX SCAN, sort skipped';
select /*+ recompile */ count(*), min(s), max(s) from (
  select sum(col1) over (partition by col2) s from t27469) x;
show trace;

evaluate '1-2v. same value as the sequential scan';
select count(*) from (
  select col1, sum(col1) over (partition by col2) s from t27469) a,
  (select col1, sum(col1) over (partition by col2) s from t27469 using index none) b
where a.col1 = b.col1 and a.s = b.s;

evaluate '1-3. ORDER BY only - PK INDEX SCAN, sort skipped';
select /*+ recompile */ count(*), sum(r) from (
  select row_number() over (order by col1) r from t27469) x;
show trace;

evaluate '1-3v. same value as the sequential scan';
select count(*) from (
  select col1, row_number() over (order by col1) r from t27469) a,
  (select col1, row_number() over (order by col1) r from t27469 using index none) b
where a.col1 = b.col1 and a.r = b.r;

--
-- 2. USING INDEX hint without a key-range condition
--
evaluate '2-1. USING INDEX hint, no condition - INDEX SCAN, sort skipped';
select /*+ recompile */ count(*), sum(d) from (
  select dense_rank() over (partition by col2 order by col1) d from t27469 using index idx_col2_col1_col3) x;
show trace;

--
-- 3. Several analytic functions
--
evaluate '3-1. index-ordered function written second - runs first (#1 sort skipped), the other sorts (#2)';
select /*+ recompile */ count(*), sum(r3), sum(d2) from (
  select rank() over (order by col3) r3,
         dense_rank() over (partition by col2 order by col1) d2 from t27469) x;
show trace;

evaluate '3-1v. same value as the sequential scan';
select count(*) from (
  select col1, rank() over (order by col3) r3,
         dense_rank() over (partition by col2 order by col1) d2 from t27469) a,
  (select col1, rank() over (order by col3) r3,
         dense_rank() over (partition by col2 order by col1) d2 from t27469 using index none) b
where a.col1 = b.col1 and a.r3 = b.r3 and a.d2 = b.d2;

evaluate '3-2. two functions whose keys are index prefixes share one sort group - #1 sort skipped';
select /*+ recompile */ count(*), min(s), max(s), sum(d) from (
  select sum(col1) over (partition by col2) s,
         dense_rank() over (partition by col2 order by col1) d from t27469) x;
show trace;

evaluate '3-2v. same value as the sequential scan';
select count(*) from (
  select col1, sum(col1) over (partition by col2) s,
         dense_rank() over (partition by col2 order by col1) d from t27469) a,
  (select col1, sum(col1) over (partition by col2) s,
         dense_rank() over (partition by col2 order by col1) d from t27469 using index none) b
where a.col1 = b.col1 and a.s = b.s and a.d = b.d;

evaluate '3-3. partition and order keys also in the select list - INDEX SCAN, sort skipped';
select /*+ recompile */ col2, col1, dense_rank() over (partition by col2 order by col1) d from t27469
where rownum <= 5;
show trace;

--
-- 4. ORDER BY of the query
--
evaluate '4-1. analytic sort skipped, query ORDER BY still sorted';
select /*+ recompile */ col1, col2, d from (
  select col1, col2, dense_rank() over (partition by col2 order by col1) d from t27469 order by col1 desc) x
where rownum <= 5;
show trace;

--
-- 5. Nullable partition column
--
drop table if exists t27469_null;
create table t27469_null (id int not null, grp int, val int);
insert into t27469_null
with recursive cte (k) as (
  select 1
  union all
  select k + 1 from cte where k < 1000
)
select n, case when mod(n, 10) = 0 then null else mod(n, 7) end, n
from (select (b.k - 1) * 1000 + a.k as n from cte a, cte b where b.k <= 20) t;
create index idx_grp_id on t27469_null (grp, id);
update statistics on t27469_null with fullscan;

evaluate '5-1. nullable grp, index (grp, id) with id NOT NULL - INDEX SCAN including the NULL partition';
select /*+ recompile */ grp, count(*), max(r) from (
  select grp, row_number() over (partition by grp order by id) r from t27469_null) x
group by grp order by grp;
show trace;

evaluate '5-1v. same value as the sequential scan';
select count(*) from (
  select id, row_number() over (partition by grp order by id) r from t27469_null) a,
  (select id, row_number() over (partition by grp order by id) r from t27469_null using index none) b
where a.id = b.id and a.r = b.r;

evaluate '5-2. NULL keys in the ORDER BY key are ties - INDEX SCAN, sort skipped';
select /*+ recompile */ count(*), sum(r), sum(dr) from (
  select rank() over (order by grp) r, dense_rank() over (order by grp) dr from t27469_null) x;
show trace;

evaluate '5-2v. same value as the sequential scan';
select count(*) from (
  select id, rank() over (order by grp) r from t27469_null) a,
  (select id, rank() over (order by grp) r from t27469_null using index none) b
where a.id = b.id and a.r = b.r;

drop index idx_grp_id on t27469_null;
create index idx_grp on t27469_null (grp);
update statistics on t27469_null with fullscan;

evaluate '5-3. nullable grp, single-column index (grp) does not hold NULL keys - TABLE SCAN';
select /*+ recompile */ grp, count(*), max(c) from (
  select grp, count(*) over (partition by grp) c from t27469_null) x
group by grp order by grp;
show trace;

--
-- 6. Cases that keep TABLE SCAN
--
evaluate '6-1. non-covering index on a large table - TABLE SCAN + sort';
select /*+ recompile */ count(*), sum(s) from (
  select sum(col6) over (partition by col2 order by col1) s from t27469) x;
show trace;

evaluate '6-2. DESC order on the ASC index - TABLE SCAN + sort';
select /*+ recompile */ count(*), sum(d) from (
  select dense_rank() over (partition by col2 order by col1 desc) d from t27469) x;
show trace;

evaluate '6-3. GROUP BY - analytic over the groups, no analytic index scan';
select /*+ recompile */ col2, count(*), rank() over (order by col2) r from t27469 group by col2 order by col2 limit 3;
show trace;

evaluate '6-4. join - no analytic index scan';
select /*+ recompile */ count(*), sum(d) from (
  select dense_rank() over (partition by a.col2 order by a.col1) d
  from t27469 a, t27469_null b where a.col1 = b.id) x;
show trace;

drop table if exists t27469_part;
create table t27469_part (col1 int not null, col2 char(1), col3 int)
partition by hash (col1) partitions 3;
insert into t27469_part select col1, col2, col3 from t27469;
create index idx_part_col2_col1 on t27469_part (col2, col1);
update statistics on t27469_part with fullscan;

evaluate '6-5. partitioned table - partitions are scanned one by one, no analytic index scan';
select /*+ recompile */ count(*), sum(d) from (
  select dense_rank() over (partition by col2 order by col1) d from t27469_part) x;
show trace;

evaluate '6-5v. same value as the sequential scan';
select count(*) from (
  select col1, dense_rank() over (partition by col2 order by col1) d from t27469_part) a,
  (select col1, dense_rank() over (partition by col2 order by col1) d from t27469_part using index none) b
where a.col1 = b.col1 and a.d = b.d;

--
-- 7. NULL partition key on the key-range path of CBRD-26473
--
drop table if exists t27469_range;
create table t27469_range (id int not null, a int, grp int);
insert into t27469_range values (1, 1, null), (2, 1, null), (3, 1, null), (4, 1, 1), (5, 1, 1), (6, 1, 2), (7, 2, null);
create index idx_a_grp_id on t27469_range (a, grp, id);

evaluate '7-1. key range on a, NULL grp rows form one partition - INDEX SCAN, sort skipped';
select /*+ recompile */ id, a, grp,
  row_number() over (partition by a, grp order by id) r,
  count(*) over (partition by a, grp) c
from t27469_range where a = 1 using index idx_a_grp_id(+);
show trace;

evaluate '7-1v. same rows forced onto the sequential scan';
select /*+ recompile */ id, a, grp,
  row_number() over (partition by a, grp order by id) r,
  count(*) over (partition by a, grp) c
from t27469_range where a = 1 using index none order by id;

set trace off;

drop table t27469_range;
drop table t27469_part;
drop table t27469_null;
drop table t27469;
