/**
 *  This test case verifies CBRD-27361: a page batch computes an output column that casts an integer column into a
 *  NUMERIC of scale 0 (EB_OP_INT2NUM), and the value it hands out carries the cast's precision and scale, as the row
 *  path's does (a value of its own digits failed the output column's check in builds with assertions).
 *
 *  Data: 10,000 rows of SMALLINT, INT and BIGINT columns.
 *
 *  Coverage:
 *    Case 1: the cast as a select list root, with and without a filter, every precision from the type's digits to 38
 *    Case 2: the cast as a GROUP BY key and an ORDER BY key, and inside an expression and an aggregate
 */

drop table if exists t_icn;
create table t_icn (s smallint, i int, b bigint, j int);
insert into t_icn select mod (level, 30000), level * 7, cast (level as bigint) * 300000000, 1 from db_root connect by level <= 10000;

evaluate 'Case 1: the cast as a select list root';
select /*+ recompile */ cast (i as numeric(12,0)) from t_icn where j > 0 and i = 77;
select /*+ recompile */ cast (i as numeric(10,0)), cast (i as numeric(38,0)) from t_icn where j > 0 and i in (7, 70000);
select /*+ recompile */ cast (s as numeric(5,0)), cast (s as numeric(20,0)) from t_icn where j > 0 and s = 11;
select /*+ recompile */ cast (b as numeric(19,0)), cast (b as numeric(38,0)) from t_icn where j > 0 and b = 300000000;
select /*+ recompile */ count (*), sum (n) from (select /*+ NO_MERGE */ cast (i as numeric(15,0)) n from t_icn where j > 0) x;
select /*+ recompile */ count (*), max (n) from (select /*+ NO_MERGE */ cast (b as numeric(30,0)) n from t_icn) x;

evaluate 'Case 2: the cast as a GROUP BY key, an ORDER BY key, inside an expression and an aggregate';
select /*+ recompile */ cast (mod (i, 3) as numeric(12,0)) k, count (*) from t_icn where j > 0 group by cast (mod (i, 3) as numeric(12,0)) order by 1;
select /*+ recompile */ cast (i as numeric(12,0)) from t_icn where j > 0 and i < 50 order by cast (i as numeric(12,0)) desc;
select /*+ recompile */ cast (i as numeric(12,0)) + 1 from t_icn where j > 0 and i = 77;
select /*+ recompile */ sum (cast (i as numeric(12,0))) from t_icn where j > 0;

drop table t_icn;
