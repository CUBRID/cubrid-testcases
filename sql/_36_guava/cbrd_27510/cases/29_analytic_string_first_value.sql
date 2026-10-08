/**
 *  This test case verifies CBRD-27510: an analytic SUM or AVG whose first value is a string the function's domain
 *  (DOUBLE) does not take raises -181 (ER_TP_CANT_COERCE) at that value, as the aggregate SUM and AVG do. develop and
 *  the earlier heads of CBRD-27510 returned no row and no error there (optdebug: an assert), the one first-value
 *  conversion failure the analytic path still answered silently.
 *
 *  Coverage:
 *    Case 1: the analytic SUM / AVG over NVL, COALESCE, NULLIF of a date, time or datetime column with a string bind,
 *            and over a string constant expression
 *    Case 2: the aggregate SUM / AVG of the same shapes (the error they raised before), and a numeric string
 */
--+ holdcas on;
drop table if exists sf_t;
create table sf_t (id int, g int, d date, tm time, dtt datetime);
insert into sf_t values (1, 1, date'2024-01-01', time'10:00:00', datetime'2024-01-01 10:00:00'), (2, 1, date'2024-01-02', time'11:00:00', datetime'2024-01-02 10:00:00'), (3, 2, NULL, NULL, NULL);

-- Case 1. The analytic functions.
evaluate 'Case 1: analytic SUM / AVG over a string first value';
prepare q from 'select id, sum(nvl(?, d)) over (partition by g) from sf_t order by id';
execute q using '10:00:00';
prepare q from 'select id, sum(? + ?) over (partition by g) from sf_t order by id';
execute q using 'B', 'a';
prepare q from 'select id, avg(nvl(?, tm)) over (partition by g) from sf_t order by id';
execute q using 'zz';
prepare q from 'select id, sum(coalesce(dtt, ?)) over (partition by g) from sf_t order by id';
execute q using 'zz';
prepare q from 'select id, avg(? + ?) over () from sf_t order by id';
execute q using 'B', 'a';
prepare q from 'select id, sum(nullif(dtt, ?)) over () from sf_t order by id';
execute q using 'zz';

-- Case 2. The aggregate functions, and a numeric string.
evaluate 'Case 2: aggregate SUM / AVG, and a numeric string';
prepare q from 'select sum(nvl(?, d)) from sf_t';
execute q using '10:00:00';
prepare q from 'select sum(? + ?) from sf_t';
execute q using 'B', 'a';
prepare q from 'select id, sum(nvl(?, d)) over (partition by g) from sf_t order by id';
execute q using '1.5';
deallocate prepare q;
drop table sf_t;
--+ holdcas off;
