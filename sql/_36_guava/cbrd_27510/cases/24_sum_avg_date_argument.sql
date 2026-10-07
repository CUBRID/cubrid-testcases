/**
 *  This test case verifies CBRD-27510: SUM and AVG over an argument resolve_domains types as a date or time fail
 *  before any row with the error the rows raised, -454 (ER_QPROC_INVALID_DATATYPE).
 *
 *  The compiler rejects SUM (d) over a date column. A NULL bind lets a date through - NVL (?, d) is typed at
 *  execution from the bind, and with a NULL bind its type is the column's. develop added such values at the rows: a
 *  second value raised -454, a single value went out as it was (SUM of one date = the date), and the analytic SUM
 *  carried a single partition value out of the window as a DOUBLE (release: no row at all; optdebug: an assert).
 *  CBRD-27510 raises -454 before any row in both the aggregate and the analytic form. The new answers are the
 *  single-row statements: SUM of one date was the date and the analytic SUM had no row; both are -454 now. The
 *  statements over two values (-454) and over a non-NULL bind keep their answers.
 *
 *  Coverage:
 *    Case 1: aggregate SUM / AVG over NVL (?, date), DATETIME, TIME, TIMESTAMP with a NULL bind, one row and two
 *    Case 2: the analytic SUM / AVG, one value in the partition and two
 *    Case 3: a non-NULL bind (a number) - the argument is numeric and the sum answers
 */
--+ holdcas on;
drop table if exists sd_t;
create table sd_t (g int, d date, dt datetime, t time, ts timestamp);
insert into sd_t values (1, date'2024-01-03', datetime'2024-01-03 10:00:00', time'10:00:00', timestamp'2024-01-03 10:00:00');

-- Case 1. The aggregate over one row, then two.
evaluate 'Case 1: aggregate SUM / AVG over a date argument';
prepare q from 'select sum(nvl(?, d)), count(*) from sd_t';
execute q using null;
prepare q from 'select avg(nvl(?, d)) from sd_t';
execute q using null;
prepare q from 'select sum(nvl(?, dt)), sum(nvl(?, t)), sum(nvl(?, ts)) from sd_t';
execute q using null, null, null;
prepare q from 'select g, sum(nvl(?, d)) from sd_t group by g';
execute q using null;
insert into sd_t values (1, date'2024-01-04', datetime'2024-01-04 10:00:00', time'11:00:00', timestamp'2024-01-04 10:00:00');
prepare q from 'select sum(nvl(?, d)) from sd_t';
execute q using null;

-- Case 2. The analytic form: one value in the partition (g = 2), then two (g = 1).
evaluate 'Case 2: analytic SUM / AVG over a date argument';
insert into sd_t values (2, date'2024-02-01', datetime'2024-02-01 10:00:00', time'12:00:00', timestamp'2024-02-01 10:00:00');
prepare q from 'select g, sum(nvl(?, d)) over (partition by g) from sd_t where g = 2';
execute q using null;
prepare q from 'select g, sum(coalesce(?, dt)) over (partition by g) from sd_t where g = 2';
execute q using null;
prepare q from 'select g, avg(nvl(?, t)) over () from sd_t where g = 2';
execute q using null;
prepare q from 'select g, sum(nvl(?, d)) over (partition by g) from sd_t where g = 1';
execute q using null;

-- Case 3. A numeric bind makes the argument numeric.
evaluate 'Case 3: a numeric bind';
prepare q from 'select sum(nvl(?, d)) from sd_t where g = 2';
execute q using 5;
prepare q from 'select g, sum(nvl(?, d)) over (partition by g) from sd_t where g = 2';
execute q using 5;
deallocate prepare q;
drop table sd_t;
--+ holdcas off;
