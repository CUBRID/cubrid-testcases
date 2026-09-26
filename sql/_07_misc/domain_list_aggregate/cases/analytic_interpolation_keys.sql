--+ holdcas on;
-- workspace#362 (map #312, dpin-17f): an analytic MEDIAN or PERCENTILE sorts a string operand in the function's class
-- (DOUBLE, DATETIME or TIME). The analytic setup now decides the class before the sort - the compiled function domain,
-- or the class the gate gave a value argument - where the sort took it from the first pair of values it compared. A
-- class over a session variable read is still confirmed by the first value the sort compares, since the statement can
-- change the variable before any row reads it. A bind or a literal given directly has no sort key, one seen through a
-- derived table column has. Every answer here is develop's but [SHARED] (D-362-01, a user decision): another
-- function's string ORDER BY key that shares the sort with a MEDIAN over a constant or a number compares in its own
-- domain, where develop compared it in the class of its first value (an error for 'b', numbers for '10' and '9').
drop table if exists ai_t;
drop table if exists ai_s;
create table ai_t (i int, p int, s varchar(20), n int, y varchar(20));
insert into ai_t values (1, 1, '1.5', 10, 'b'), (2, 1, '2.5', 9, 'a'), (3, 2, '3.5', 8, 'c'), (4, 2, '10', 7, '10'), (5, 2, '9', 6, '9');
create table ai_s (i int, p int, n int, y varchar(20));
insert into ai_s values (1, 1, 5, 'b'), (2, 1, 5, 'a'), (3, 1, 4, 'c'), (4, 2, 5, '10'), (5, 2, 5, '9'), (6, 2, 5, 'x');

-- [DERIVED] a string bind seen through a derived table column (NO_MERGE and WHERE keep it a list): its class is the gate's
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

-- [DIRECT] a bind or a literal given directly is constant: no sort key
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

-- [SESSION] a session variable the statement does not change: its class is the gate's, which the first value confirms
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

-- [SESSION_CHANGED] a derived table changes the variable before any row reads it: the first value's class, as develop's
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

-- [COMPILED] a string column is DOUBLE at compile time (D-335-10)
select i, median(s) over (partition by p) m from ai_t order by i;
select i, percentile_disc(0.5) within group (order by s) over () m from ai_t order by i;

-- [SHARED] another function's string ORDER BY key sharing the sort compares in its own domain (dpin's answers)
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
