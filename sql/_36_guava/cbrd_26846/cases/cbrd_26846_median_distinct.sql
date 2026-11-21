/*
 * This test case verifies CBRD-26846 (follow-up): MEDIAN(DISTINCT) on the
 * buildvalue path of the parallel heap scan, and the DISTINCT keyword of a
 * printed MEDIAN.
 *
 * Bug 1: a parallel worker added the DISTINCT operand to the distinct list as
 * is, while the list holds the MEDIAN domain (DOUBLE for a number or a string
 * operand). An INT/NUMERIC/VARCHAR operand broke the list tuple (debug abort,
 * garbage value in release).
 * Fix 1: the worker casts the value to the MEDIAN domain before adding it,
 * as the serial scan does.
 *
 * Bug 2: MEDIAN(DISTINCT a) was printed as median(a). The printed query is
 * the XASL cache key, so MEDIAN(a) and MEDIAN(DISTINCT a) shared one cached
 * plan (the one compiled first ran for both), and a view lost DISTINCT.
 * Fix 2: MEDIAN(DISTINCT a) is printed as median(distinct a).
 *
 * Data: k is NULL for 10% of the rows, a multiple of 4 (0..96) for 25% and 0
 * otherwise, so MEDIAN(DISTINCT k) = 48 and MEDIAN(k) = 0. A plan that drops
 * or adds DISTINCT gives the other value.
 *
 * Table sizing: 6000 rows with three md5 strings each (incompressible) give
 * more heap pages than the parallel scan threshold that CTP test_mode=yes
 * sets (32 pages). Table and column names have no digits so CTP does not
 * mask them.
 *
 * Coverage:
 *   Case 1: PARALLEL(8) vs NO_PARALLEL_SCAN MEDIAN(DISTINCT) over INT,
 *           NUMERIC, VARCHAR, next to MEDIAN without DISTINCT and other
 *           DISTINCT aggregates -> gather: buildvalue
 *   Case 2: MEDIAN(DISTINCT k) then MEDIAN(k) on the same table without
 *           recompile -> 48, then 0 (parallel and serial)
 *   Case 3: MEDIAN(k) then MEDIAN(DISTINCT k) -> 0, then 48
 *   Case 4: a view keeps MEDIAN(DISTINCT)
 */

drop view if exists vmd;
drop table if exists md, mda, mdb;
create table md (id int, k int, n numeric(10,2), v varchar(10), pad varchar(100));
insert into md
select id, k, k / 4.0, cast(k as varchar), pad
from (select rownum id, if(mod(rownum, 10) = 3, null, if(mod(rownum, 4) = 0, mod(rownum, 100), 0)) k,
             concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7)) pad
      from db_class a, db_class b, db_class c, db_class d, db_class e limit 6000) x;
create table mda as select id, k, pad from md;
create table mdb as select id, k, pad from md;

set trace on;

evaluate 'Case 1: MEDIAN(DISTINCT) over INT, NUMERIC, VARCHAR -> gather: buildvalue';
select case when p.mi <=> s.mi and p.mn <=> s.mn and p.mv <=> s.mv and p.ma <=> s.ma
             and p.cd <=> s.cd and p.sd <=> s.sd and p.mi = 48 and p.mn = 12 and p.mv = 48 and p.ma = 0
            then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ median(distinct k) mi, median(distinct n) mn, median(distinct v) mv, median(k) ma,
             count(distinct k) cd, sum(distinct k) sd from md) p,
     (select /*+ NO_PARALLEL_SCAN */ median(distinct k) mi, median(distinct n) mn, median(distinct v) mv, median(k) ma,
             count(distinct k) cd, sum(distinct k) sd from md) s;
show trace;

set trace off;

evaluate 'Case 2: MEDIAN(DISTINCT k) then MEDIAN(k) -> 48, 0';
select /*+ PARALLEL(8) */ median(distinct k) from mda;
select /*+ PARALLEL(8) */ median(k) from mda;
select /*+ NO_PARALLEL_SCAN */ median(distinct k) from mda;
select /*+ NO_PARALLEL_SCAN */ median(k) from mda;

evaluate 'Case 3: MEDIAN(k) then MEDIAN(DISTINCT k) -> 0, 48';
select /*+ PARALLEL(8) */ median(k) from mdb;
select /*+ PARALLEL(8) */ median(distinct k) from mdb;
select /*+ NO_PARALLEL_SCAN */ median(k) from mdb;
select /*+ NO_PARALLEL_SCAN */ median(distinct k) from mdb;

evaluate 'Case 4: a view keeps MEDIAN(DISTINCT)';
create view vmd as select median(distinct k) m from md;
select if(vclass_def like '%median(distinct %', 'PASS', 'FAIL') result from db_vclass where vclass_name = 'vmd';
select m from vmd;

drop view vmd;
drop table md, mda, mdb;
