/**
 *  This test case verifies CBRD-28049: the page batch data filter no longer leaves an error behind or refuses its
 *  own compiled image
 *
 *  (1) The page batch evaluates the filter over a chunk of a page's rows and hands the chunk back to the row path
 *  when a term raises an error on a row. It kept that error: when a LIMIT or an EXISTS stopped the row path before
 *  the row, the query went on with the error still set. A statement that then inserts rows failed with it - the heap
 *  insert takes an error set before it for its own - and a parallel ORDER BY asserted on a debug build when it merged
 *  its runs. The filter here reaches the batch through c = c, and the last row of t_ovf overflows cast (c as bigint).
 *  (2) The image of a data filter whose share registry had more entries than its program has cells was refused -
 *  CASE x WHEN x gives both x one cell, and the registry has an entry for each - so a debug build asserted when the
 *  scan first evaluated the filter, and a release build ran the filter interpreted. Each such query is followed by
 *  the same term written with x once, through NVL2, and the two results match.
 *
 *  Coverage:
 *    Case 1:  LIMIT 1 and EXISTS that stop before the overflowing row return their row
 *    Case 2:  INSERT ... SELECT whose EXISTS stops before the overflow inserts every row, parallel or serial sort
 *    Case 3:  CREATE TABLE ... AS SELECT whose EXISTS stops before the overflow creates the table with its rows
 *    Case 4:  a query that reads the overflowing row still fails with the overflow
 *    Case 5:  a parallel scan whose worker meets the overflowing row fails with the overflow too, and a leaf that
 *             drops that row before the cast keeps the other rows
 *    Case 6:  outer join ON terms that read CASE x WHEN x of the outer column return the rows of the NVL2 form
 *    Case 7:  an outer string that is not a number fails with the cast error, as the NVL2 form does
 */

drop table if exists t_ovf;
drop table if exists t_big;
drop table if exists t_sorted;
drop table if exists t_ctas;
create table t_ovf (c double);
-- the first row satisfies the filter, and cast (9.3e18 as bigint) overflows
insert into t_ovf values (0.5e0), (0.25e0), (1.0e0), (9.3e18);
create table t_big (a int, b varchar(200));
insert into t_big select rownum, repeat('x', 200) from db_class a, db_class b, db_class c limit 50000;
update statistics on t_big with fullscan;
create table t_sorted (a int, b varchar(200));

evaluate 'Case 1: LIMIT 1 and EXISTS that stop before the overflowing row return their row';
select 1 from t_ovf where c = c and c <> cast(c as bigint) limit 1;
select 2 from db_root where exists (select 1 from t_ovf where c = c and c <> cast(c as bigint));

evaluate 'Case 2: INSERT ... SELECT whose EXISTS stops before the overflow inserts every row, parallel or serial sort';
insert into t_sorted select /*+ parallel(2) no_parallel_scan */ a, b from t_big where exists (select 1 from t_ovf where c = c and c <> cast(c as bigint)) order by a;
select count(*), sum(a), min(a), max(a) from t_sorted;
delete from t_sorted;
insert into t_sorted select /*+ parallel(1) */ a, b from t_big where exists (select 1 from t_ovf where c = c and c <> cast(c as bigint)) order by a;
select count(*), sum(a), min(a), max(a) from t_sorted;

evaluate 'Case 3: CREATE TABLE ... AS SELECT whose EXISTS stops before the overflow creates the table with its rows';
create table t_ctas as select a from t_big where a <= 5 and exists (select 1 from t_ovf where c = c and c <> cast(c as bigint));
select a from t_ctas order by a;

evaluate 'Case 4: a query that reads the overflowing row still fails with the overflow';
select c from t_ovf where c = c and c <> cast(c as bigint) order by 1;

-- the overflowing row sits between two runs of 200000 rows: the worker whose chunk meets it hands the chunk to the
-- row path, which raises the overflow again at that row
drop table if exists t_px;
create table t_px (c double);
insert into t_px select rownum + 0.5e0 from db_class a, db_class b, db_class c limit 200000;
insert into t_px values (9.3e18);
insert into t_px select rownum + 0.5e0 from db_class a, db_class b, db_class c limit 200000;
update statistics on t_px with fullscan;

evaluate 'Case 5: a parallel scan whose worker meets the overflowing row fails with the overflow too';
select /*+ parallel(4) */ count(*) from t_px where c = c and c <> cast(c as bigint);
-- c < 1000 drops the overflowing row before the cast: 999 rows of each run
select /*+ parallel(4) */ count(*) from t_px where c = c and c <> cast(c as bigint) and c < 1000;

drop table t_ovf;
drop table t_big;
drop table t_sorted;
drop table t_ctas;
drop table t_px;

drop table if exists t_out;
drop table if exists t_in;
create table t_out (c0 varchar(20));
create table t_in (c0 double);
insert into t_out values ('12'), ('-3'), (null);
insert into t_in values (1.5e0), (20.0e0), (-7.0e0), (null);

-- x is cast(cast(t_out.c0 as bigint) as double). The ON term is the data filter of the scan of t_in, where t_out.c0
-- is a value; CASE x WHEN x gives both x one cell, and NVL2 (x, ...) reads x once
evaluate 'Case 6: outer join ON terms that read CASE x WHEN x of the outer column return the rows of the NVL2 form';
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 <> (case cast(cast(t_out.c0 as bigint) as double) when cast(cast(t_out.c0 as bigint) as double) then t_out.c0 else t_out.c0 end)) order by 1, 2;
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 <> nvl2(cast(cast(t_out.c0 as bigint) as double), t_out.c0, t_out.c0)) order by 1, 2;
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 = (case cast(cast(t_out.c0 as bigint) as double) when cast(cast(t_out.c0 as bigint) as double) then t_out.c0 else t_out.c0 end)) order by 1, 2;
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 = nvl2(cast(cast(t_out.c0 as bigint) as double), t_out.c0, t_out.c0)) order by 1, 2;
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 = (case cast(cast(t_out.c0 as bigint) as double) when cast(cast(t_out.c0 as bigint) as double) then t_out.c0 else t_out.c0 end) and t_in.c0 > 0) order by 1, 2;
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 = nvl2(cast(cast(t_out.c0 as bigint) as double), t_out.c0, t_out.c0) and t_in.c0 > 0) order by 1, 2;

evaluate 'Case 7: an outer string that is not a number fails with the cast error, as the NVL2 form does';
insert into t_out values ('abc');
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 = (case cast(cast(t_out.c0 as bigint) as double) when cast(cast(t_out.c0 as bigint) as double) then t_out.c0 else t_out.c0 end)) order by 1, 2;
select t_out.c0, t_in.c0 from t_out left outer join t_in on (t_out.c0 = nvl2(cast(cast(t_out.c0 as bigint) as double), t_out.c0, t_out.c0)) order by 1, 2;

drop table t_out;
drop table t_in;
