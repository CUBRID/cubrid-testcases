/**
 *  This test case verifies CBRD-27510: an analytic MEDIAN or PERCENTILE decides the class of a string sort key
 *  before the sort.
 *
 *  An analytic MEDIAN, PERCENTILE_CONT or PERCENTILE_DISC sorts a string operand in the function's class - DOUBLE,
 *  DATETIME or TIME. develop took the class from the first pair of values the sort compared. CBRD-27510 decides it
 *  in the analytic setup before the sort, from the compiled function domain or from the class the gate
 *  (qexec_resolve_domains) gave a value argument. A class over a session variable is the one its value gives when
 *  the execution starts, for the whole statement. A bind or a literal given directly is constant and has no sort
 *  key, one seen through a derived table column has one.
 *
 *  The answers are develop's except three cases. Case 2 - a set operation's string column is DOUBLE by its type, so
 *  a first value such as '01:00:00' is -1118 (develop typed the column TIME by that first value and failed at 'abc'
 *  with -181). Case 5 - a session variable's class is the one its value gives when the execution starts, so the
 *  values a derived table assigns before any row reads the variable fail the conversion with -181. Case 7 - another
 *  analytic function's string ORDER BY key that shares the sort with a MEDIAN over a constant or a number compares
 *  in its own domain. develop compared it in the class of the MEDIAN's first value, so 'b' raised an error and '10'
 *  and '9' sorted as numbers.
 *
 *  Coverage:
 *    Case 1: a string bind seen through a derived table column
 *    Case 2: a set operation's column over string binds
 *    Case 3: a bind or a literal given directly, which has no sort key
 *    Case 4: a session variable the statement does not change
 *    Case 5: a session variable a derived table changes before any row reads it
 *    Case 6: a string column, DOUBLE at compile time
 *    Case 7: another function's string ORDER BY key sharing the sort with a MEDIAN
 */
--+ holdcas on;
drop table if exists ai_t;
drop table if exists ai_s;
create table ai_t (i int, p int, s varchar(20), n int, y varchar(20));
insert into ai_t values (1, 1, '1.5', 10, 'b'), (2, 1, '2.5', 9, 'a'), (3, 2, '3.5', 8, 'c'), (4, 2, '10', 7, '10'), (5, 2, '9', 6, '9');
create table ai_s (i int, p int, n int, y varchar(20));
insert into ai_s values (1, 1, 5, 'b'), (2, 1, 5, 'a'), (3, 1, 4, 'c'), (4, 2, 5, '10'), (5, 2, 5, '9'), (6, 2, 5, 'x');

-- Case 1 [DERIVED]. A string bind seen through a derived table column, kept a list by NO_MERGE and the WHERE
-- clause. Its class is the one the gate gives the bind's value.
evaluate 'Case 1: a string bind through a derived table column';
prepare q from 'select dt.i, median(dt.x) over (partition by dt.p) m from (select /*+ NO_MERGE */ i, p, ? x from ai_t where i > 0) dt order by dt.i';
execute q using '1.5';
execute q using '2024-01-02 10:00:00';
execute q using '10:00:00';
execute q using 'abc';
execute q using null;
prepare q from 'select dt.i, percentile_disc(0.5) within group (order by dt.x) over (partition by dt.p) m from (select /*+ NO_MERGE */ i, p, ? x from ai_t where i > 0) dt order by dt.i';
execute q using '1.5';
execute q using '2024-01-02 10:00:00';
execute q using '10:00:00';
execute q using 'abc';
execute q using null;
prepare q from 'select dt.i, percentile_cont(0.5) within group (order by dt.x) over (partition by dt.p) m from (select /*+ NO_MERGE */ i, p, ? x from ai_t where i > 0) dt order by dt.i';
execute q using '1.5';
execute q using '2024-01-02 10:00:00';
execute q using '10:00:00';
execute q using 'abc';
execute q using null;
prepare q from 'select median(dt.x) over () m from (select ? x from ai_t where i = 1 union all select ? x from ai_t where i > 1) dt';
execute q using '1.5', '1.5';
deallocate prepare q;

-- Case 2 [SETOP]. A set operation's column over string binds is DOUBLE by its type. A first value that does not
-- convert is -1118, as an aggregate's first value is, and a later one fails as the row's conversion does (-181).
evaluate 'Case 2: a set operation column over string binds';
prepare q from 'select median(dt.x) over () m from (select ? x from ai_t where i = 1 union all select ? x from ai_t where i > 1) dt';
execute q using 'abc', 'abc';
execute q using '1.5', 'abc';
execute q using '01:00:00', 'abc';
prepare q from 'select percentile_cont(0.5) within group (order by dt.x) over () m from (select ? x from ai_t where i = 1 union all select ? x from ai_t where i > 1) dt';
execute q using 'abc', 'abc';
prepare q from 'select percentile_disc(0.5) within group (order by dt.x) over () m from (select ? x from ai_t where i = 1 union all select ? x from ai_t where i > 1) dt';
execute q using 'abc', 'abc';
prepare q from 'select median(dt.x) m from (select ? x from ai_t where i = 1 union all select ? x from ai_t where i > 1) dt';
execute q using 'abc', 'abc';
deallocate prepare q;

-- Case 3 [DIRECT]. A bind or a literal given directly is constant, so it has no sort key.
evaluate 'Case 3: a bind or a literal given directly';
prepare q from 'select i, median(?) over (partition by p) m from ai_t order by i';
execute q using '1.5';
execute q using '2024-01-02 10:00:00';
execute q using '10:00:00';
execute q using 'abc';
execute q using null;
execute q using 1.5;
execute q using 7;
prepare q from 'select i, percentile_disc(0.5) within group (order by ?) over (partition by p) m from ai_t order by i';
execute q using '1.5';
execute q using '10:00:00';
execute q using 'abc';
deallocate prepare q;
select i, median('2024-01-02 10:00:00') over (partition by p) m from ai_t order by i;
select i, percentile_cont(0.5) within group (order by '10:00:00') over (partition by p) m from ai_t order by i;

-- Case 4 [SESSION]. A session variable the statement does not change - its class is the one the gate gives its
-- value.
evaluate 'Case 4: a session variable the statement does not change';
set @v = '1.5';
select i, median(@v) over (partition by p) m1 from ai_t order by i;
set @v = '2024-01-02 10:00:00';
select i, median(@v) over (partition by p) m2 from ai_t order by i;
set @v = '10:00:00';
select i, percentile_disc(0.5) within group (order by @v) over (partition by p) m3 from ai_t order by i;
set @v = 'abc';
select i, median(@v) over (partition by p) m4 from ai_t order by i;
set @v = null;
select i, median(@v) over (partition by p) m5 from ai_t order by i;
deallocate variable @v;

-- Case 5 [SESSION_CHANGED]. A derived table changes the variable before any row reads it. The class is the start
-- value's ('1.5', DOUBLE), and the changed values fail its conversion. develop took the class of the changed value
-- and answered TIME and DATETIME values, and -1118 for 'abc'.
evaluate 'Case 5: a session variable changed before any row reads it';
set @m = '1.5';
select i, median(@m) over (partition by p) m1, @m v from (select (@m := '01:00:00') x from db_root) d, ai_t order by i;
set @m = '1.5';
select i, percentile_disc(0.5) within group (order by @m) over (partition by p) m2, @m v from (select (@m := '2024-01-02 10:00:00') x from db_root) d, ai_t order by i;
set @m = '1.5';
select i, percentile_cont(0.5) within group (order by @m) over (partition by p) m3, @m v from (select (@m := '3.5') x from db_root) d, ai_t order by i;
set @m = null;
select i, median(@m) over (partition by p) m4, @m v from (select (@m := '01:00:00') x from db_root) d, ai_t order by i;
set @m = '1.5';
select i, median(@m) over (partition by p) m5, @m v from (select (@m := 'abc') x from db_root) d, ai_t order by i;
deallocate variable @m;

-- Case 6 [COMPILED]. A string column is DOUBLE at compile time.
evaluate 'Case 6: a string column';
select i, median(s) over (partition by p) m from ai_t order by i;
select i, percentile_disc(0.5) within group (order by s) over () m from ai_t order by i;

-- Case 7 [SHARED]. ROW_NUMBER, RANK or DENSE_RANK over a string ORDER BY key that shares the sort with a MEDIAN or
-- PERCENTILE over a constant or a number compares the key as a string. The same ROW_NUMBER without the MEDIAN comes
-- first for comparison. develop compared the key in the class of the MEDIAN's first value - -1118 for keys such as
-- 'b', and numeric order for '10' and '9'.
evaluate 'Case 7: a string key sharing the sort with a MEDIAN';
select i, row_number() over (order by y) r from ai_t order by i;
select i, median(1) over () m, row_number() over (order by y) r from ai_t order by i;
select i, row_number() over (order by s) r from ai_t order by i;
select i, median(1) over () m, row_number() over (order by s) r from ai_t order by i;
select i, median(n) over (partition by p) m, rank() over (partition by p order by n, y) r from ai_s order by i;
select i, percentile_cont(0.5) within group (order by n) over (partition by p) m, dense_rank() over (partition by p order by n, y) r from ai_s order by i;
prepare q from 'select i, median(?) over () m, row_number() over (order by y) r from ai_t order by i';
execute q using 7;
execute q using '1.5';
deallocate prepare q;

drop table ai_t;
drop table ai_s;
--+ holdcas off;
