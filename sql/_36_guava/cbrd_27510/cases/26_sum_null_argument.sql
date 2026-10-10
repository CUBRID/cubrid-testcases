/**
 *  This test case verifies CBRD-27510: SUM and AVG over an argument the compiler typed NULL - a NULL constant, a cast
 *  of one, an expression folded to NULL, a CASE whose arms are all NULL - see only NULLs and answer NULL, as develop
 *  did. The function's accumulator is derived from the argument's type before any row; a NULL type derives none, and
 *  the setup refused the function as unresolved before the fix (-1383 at execute, the review of PR 8022).
 *
 *  Coverage:
 *    Case 1: SUM over a NULL constant argument, in the shapes the review reported: a cast, an expression, DISTINCT,
 *            NVL, CASE, GROUP BY, an inline view, a UNION ALL branch, a parallel hint, INSERT ... SELECT, no row
 *    Case 2: the functions that answered: MAX, MIN, AVG, COUNT, STDDEV, MEDIAN over NULL, SUM over a NULL bind, the
 *            analytic SUM, a CASE with a column arm, SUM (a) + SUM (NULL)
 *    Case 3: an arithmetic over NULL and a bind, folded to NULL by the compiler (SUM (NULL + ?)), with INT, string and
 *            DOUBLE binds, in GROUP BY and in the analytic form
 */
--+ holdcas on;
drop table if exists sn_t, sn_s;
create table sn_t (a int);
insert into sn_t values (10), (20);
create table sn_s (s int);

-- Case 1. SUM over a NULL constant argument.
evaluate 'Case 1: SUM over a NULL constant argument';
select sum(null), typeof(sum(null)) from sn_t;
select sum(cast(null as int)), sum(cast(null as numeric(10,2))), sum(cast(null as double)) from sn_t;
select sum(null + 0), sum(null * a), sum(distinct null), sum(nvl(null, null)) from sn_t;
select sum(case when a > 100 then null end) from sn_t;
select a, sum(null) from sn_t group by a order by a;
select * from (select sum(null) s from sn_t) v;
select sum(a) from sn_t union all select sum(null) from sn_t;
select /*+ PARALLEL(4) */ sum(null) from sn_t;
select sum(null) from sn_t where a > 100;
insert into sn_s select sum(null) from sn_t;
select * from sn_s;
select avg(cast(null as numeric(10,2))), avg(null + 0) from sn_t;

-- Case 2. The functions that answered.
evaluate 'Case 2: the functions that answered';
select max(null), min(null), avg(null), count(null), stddev(null), median(null), avg(cast(null as int)) from sn_t;
prepare q from 'select sum(?) from sn_t';
execute q using null;
select sum(null) over () from sn_t;
select sum(case when a > 100 then a else null end), sum(a) + sum(null) from sn_t;

-- Case 3. NULL plus a bind.
evaluate 'Case 3: an arithmetic over NULL and a bind';
prepare q from 'select sum(null + ?), typeof(sum(null + ?)) from sn_t';
execute q using 1, 1;
execute q using 'x', 'x';
execute q using 1.5, 1.5;
prepare q from 'select sum(cast(null as int) + ?), sum(? + null), sum(null * ?) from sn_t';
execute q using 1, 1, 1;
prepare q from 'select a, sum(null + ?) from sn_t group by a order by a';
execute q using 1;
prepare q from 'select avg(cast(null as int) + ?), max(null + ?), count(null + ?) from sn_t';
execute q using 1, 1, 1;
prepare q from 'select sum(null + ?) over () from sn_t';
execute q using 1;
deallocate prepare q;
drop table sn_t, sn_s;
--+ holdcas off;
