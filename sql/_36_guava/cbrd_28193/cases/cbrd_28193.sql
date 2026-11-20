-- CBRD-28193: the number of groups of a GROUP BY or DISTINCT is the product of the column NDVs, at most the number
-- of rows that are grouped. The product was kept in INT64 and overflowed with several columns, so the derived table
-- was estimated at 1e19, 1 or 0 rows. A column holding a single value was estimated as one group per row.
-- Each case joins the derived table t with t_dim on its primary key: an index join is right when t has a few
-- rows, a hash join when it has tens of thousands.

drop table if exists t_big, t_pow, t_wide, t_dim;
-- 60000 rows, a b c d unique, e has 10 values, k has one value
create table t_big (a int, b int, c int, d int, e int, k int);
insert into t_big select rownum, rownum, rownum, rownum, mod(rownum, 10), 7 from db_root connect by level <= 60000;
-- 65536 rows, the NDV product of the four columns is 2^64
create table t_pow (a int, b int, c int, d int);
insert into t_pow select rownum, rownum, rownum, rownum from db_root connect by level <= 65536;
-- 300 rows, the NDV product of the eight columns is 300^8
create table t_wide (c1 int, c2 int, c3 int, c4 int, c5 int, c6 int, c7 int, c8 int);
insert into t_wide select rownum, rownum, rownum, rownum, rownum, rownum, rownum, rownum from db_root connect by level <= 300;
create table t_dim (id int primary key, v int);
insert into t_dim select rownum, rownum from db_root connect by level <= 60000;
update statistics on t_big, t_pow, t_wide, t_dim with fullscan;

-- T1: four unique columns with a filter, t has 30000 rows: hash join (was estimated at 1 row, index join)
--@queryplan
select /*+ recompile */ count(*)
from (select a, b, c, d, count(*) n from t_big where e < 5 group by a, b, c, d) t, t_dim m
where t.a = m.id;

-- T2: the product is a multiple of 2^64, t has 65536 rows: hash join (was estimated at 0 rows, index join)
--@queryplan
select /*+ recompile */ count(*)
from (select a, b, c, d, count(*) n from t_pow group by a, b, c, d) t, t_dim m
where t.a = m.id;

-- T3: eight columns of a small table, t has 300 rows: index join (was estimated at 1e19 rows, hash join)
--@queryplan
select /*+ recompile */ count(*)
from (select c1, c2, c3, c4, c5, c6, c7, c8, count(*) n from t_wide group by c1, c2, c3, c4, c5, c6, c7, c8) t, t_dim m
where t.c1 = m.id;

-- T4: DISTINCT multiplies the columns of the select list, t has 300 rows: index join (was a hash join)
--@queryplan
select /*+ recompile */ count(*)
from (select distinct c1, c2, c3, c4, c5, c6, c7, c8 from t_wide) t, t_dim m
where t.c1 = m.id;

-- T5: a column holding a single value makes one group: index join (was estimated at 60000 rows, hash join)
--@queryplan
select /*+ recompile */ count(*)
from (select k, count(*) n from t_big group by k) t, t_dim m
where t.k = m.id;

-- T6: the same with DISTINCT
--@queryplan
select /*+ recompile */ count(*)
from (select distinct k from t_big) t, t_dim m
where t.k = m.id;

-- T7: no overflow, three unique columns, t has 60000 rows: hash join, unchanged
--@queryplan
select /*+ recompile */ count(*)
from (select a, b, c, count(*) n from t_big group by a, b, c) t, t_dim m
where t.a = m.id;

drop table if exists t_big, t_pow, t_wide, t_dim;
