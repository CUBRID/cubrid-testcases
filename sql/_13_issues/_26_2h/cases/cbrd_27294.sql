/**
 *  This test case verifies CBRD-27294: DISTINCT aggregate and analytic functions on a host variable
 *
 *  The DISTINCT or sort list kept the unresolved domain of the host variable, so its values were lost
 *  or not deduplicated. MEDIAN and PERCENTILE_CONT on a constant now return DOUBLE like on a column.
 *
 *  Coverage:
 *    Case 1:  the issue repro, aggregate and analytic, gives the bind value
 *    Case 2:  INT, BIGINT and NUMERIC binds, aggregate and analytic
 *    Case 3:  DOUBLE, FLOAT and MONETARY binds, aggregate and analytic
 *    Case 4:  a CHAR bind sums as DOUBLE, a NULL bind gives NULL with no error
 *    Case 5:  GROUP BY and PARTITION BY set the domain for every group
 *    Case 6:  STDDEV and VARIANCE family, analytic MIN and MAX
 *    Case 7:  GROUP_CONCAT ORDER BY on a host variable with no DISTINCT
 *    Case 8:  three distinct bound values are deduplicated and ordered
 *    Case 9:  controls - column, literal, CAST of the host variable in the query text
 *    Case 10: MEDIAN on a literal or a host variable returns DOUBLE
 *    Case 11: PERCENTILE_CONT returns DOUBLE, PERCENTILE_DISC keeps INT
 *    Case 12: a CHAR bind of MEDIAN and PERCENTILE_CONT casts to DOUBLE, a DATE bind keeps DATE
 */

drop table if exists tdist;
create table tdist (a int);
insert into tdist select rownum from db_class x, db_class y limit 50;


evaluate 'Case 1: the repro - SUM, AVG and GROUP_CONCAT DISTINCT and SUM DISTINCT OVER () on a host variable give the bind value';
set @v = cast(10 as int);
prepare s from 'select sum(distinct ?), avg(distinct ?) from tdist';
execute s using @v, @v;
deallocate prepare s;
prepare s from 'select group_concat(distinct ?) from tdist';
execute s using @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over () from tdist';
execute s using @v;
deallocate prepare s;


evaluate 'Case 2: INT, BIGINT and NUMERIC binds give one distinct value, aggregate and analytic; aggregate MIN and MAX are unchanged controls';
-- the engine runs an aggregate MIN or MAX DISTINCT as MIN or MAX ALL, so only the analytic MIN and MAX of Case 6 take a DISTINCT list
set @v = cast(10 as int);
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
set @v = cast(9000000000 as bigint);
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
set @v = cast(123.456 as numeric(10,3));
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;


evaluate 'Case 3: DOUBLE, FLOAT and MONETARY binds give one distinct value, aggregate and analytic; aggregate MIN and MAX are unchanged controls';
set @v = cast(1.5 as double);
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
set @v = cast(2.5 as float);
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
set @v = cast(7.25 as monetary);
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;


evaluate 'Case 4: a CHAR bind sums as DOUBLE while MIN and MAX keep the CHAR value; a NULL bind gives NULL and a count of 0 with no error';
set @v = cast('123' as char(3));
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
set @v = null;
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select sum(distinct ?), avg(distinct ?), min(distinct ?), max(distinct ?), count(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct ?) over (), avg(distinct ?) over (), count(distinct ?) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;


evaluate 'Case 5: GROUP BY and PARTITION BY - the DISTINCT list of each group gives 10 and a count of 1';
-- the list file is made again for each group, so the domain must be set for every group, not only the first
set @v = cast(10 as int);
prepare s from 'select a % 3 as g, count(*) as cnt, sum(distinct ?), avg(distinct ?), count(distinct ?) from tdist group by a % 3 order by 1';
execute s using @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct a % 3 as g, count(*) over (partition by a % 3) as cnt, sum(distinct ?) over (partition by a % 3), avg(distinct ?) over (partition by a % 3), count(distinct ?) over (partition by a % 3) from tdist order by 1';
execute s using @v, @v, @v;
deallocate prepare s;


evaluate 'Case 6: the other DISTINCT functions on a host variable - STDDEV and VARIANCE family, analytic MIN and MAX';
set @v = cast(10 as int);
prepare s from 'select stddev(distinct ?), stddev_pop(distinct ?), stddev_samp(distinct ?), variance(distinct ?), var_pop(distinct ?), var_samp(distinct ?) from tdist';
execute s using @v, @v, @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct min(distinct ?) over (), max(distinct ?) over () from tdist';
execute s using @v, @v;
deallocate prepare s;


evaluate 'Case 7: GROUP_CONCAT with ORDER BY and no DISTINCT on a host variable gives every bound value, like the literal control';
select group_concat(10 order by 1) from tdist where a <= 5;
set @v = cast(10 as int);
prepare s from 'select group_concat(? order by 1) from tdist where a <= 5';
execute s using @v;
deallocate prepare s;


evaluate 'Case 8: three distinct bound values over 50 rows are deduplicated and ordered, with the same values and order as the literal control';
-- each of the three values repeats on about 17 rows, so both the duplicate elimination and the order of the list show
select sum(distinct case when a % 3 = 0 then 30 when a % 3 = 1 then 10 else 20 end), count(distinct case when a % 3 = 0 then 30 when a % 3 = 1 then 10 else 20 end), group_concat(distinct case when a % 3 = 0 then 30 when a % 3 = 1 then 10 else 20 end order by 1) from tdist;
set @v1 = cast(30 as int);
set @v2 = cast(10 as int);
set @v3 = cast(20 as int);
prepare s from 'select sum(distinct case when a % 3 = 0 then ? when a % 3 = 1 then ? else ? end), count(distinct case when a % 3 = 0 then ? when a % 3 = 1 then ? else ? end), group_concat(distinct case when a % 3 = 0 then ? when a % 3 = 1 then ? else ? end order by 1) from tdist';
execute s using @v1, @v2, @v3, @v1, @v2, @v3, @v1, @v2, @v3;
deallocate prepare s;
prepare s from 'select distinct sum(distinct case when a % 3 = 0 then ? when a % 3 = 1 then ? else ? end) over (), count(distinct case when a % 3 = 0 then ? when a % 3 = 1 then ? else ? end) over () from tdist';
execute s using @v1, @v2, @v3, @v1, @v2, @v3;
deallocate prepare s;


evaluate 'Case 9: controls - a column, a literal and a CAST of the host variable in the query text';
select sum(distinct a % 10), avg(distinct a % 10), count(distinct a % 10), group_concat(distinct a % 10 order by a % 10) from tdist;
select sum(distinct 10), avg(distinct 10), count(distinct 10), group_concat(distinct 10) from tdist;
select distinct sum(distinct 10) over (), avg(distinct 10) over (), count(distinct 10) over () from tdist;
set @v = cast(10 as int);
prepare s from 'select sum(distinct cast(? as int)), avg(distinct cast(? as int)), count(distinct cast(? as int)), group_concat(distinct cast(? as int)) from tdist';
execute s using @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct sum(distinct cast(? as int)) over (), avg(distinct cast(? as int)) over (), count(distinct cast(? as int)) over () from tdist';
execute s using @v, @v, @v;
deallocate prepare s;


evaluate 'Case 10: MEDIAN on a literal or an INT host variable returns DOUBLE like MEDIAN on a column, aggregate and analytic';
select median(10), typeof(median(10)), median(distinct 10), median(a), typeof(median(a)), median(distinct a) from tdist;
select distinct median(10) over (), median(distinct 10) over (), typeof(median(distinct 10) over ()), median(a) over (), median(distinct a) over () from tdist;
select median(cast(10 as int)), typeof(median(cast(10 as int))) from tdist;
set @v = cast(10 as int);
prepare s from 'select median(?), typeof(median(?)), median(distinct ?), typeof(median(distinct ?)) from tdist';
execute s using @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct median(?) over (), median(distinct ?) over (), typeof(median(distinct ?) over ()) from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
prepare s from 'select a % 3 as g, median(?), median(distinct ?) from tdist group by a % 3 order by 1';
execute s using @v, @v;
deallocate prepare s;
prepare s from 'select distinct a % 3 as g, median(distinct ?) over (partition by a % 3) from tdist order by 1';
execute s using @v;
deallocate prepare s;


evaluate 'Case 11: PERCENTILE_CONT on a literal or an INT host variable returns DOUBLE; PERCENTILE_DISC keeps INT as an unchanged control';
select percentile_cont(0.5) within group (order by 10), typeof(percentile_cont(0.5) within group (order by 10)), percentile_disc(0.5) within group (order by 10), typeof(percentile_disc(0.5) within group (order by 10)) from tdist;
set @v = cast(10 as int);
prepare s from 'select percentile_cont(0.5) within group (order by ?), typeof(percentile_cont(0.5) within group (order by ?)), percentile_disc(0.5) within group (order by ?), typeof(percentile_disc(0.5) within group (order by ?)) from tdist';
execute s using @v, @v, @v, @v;
deallocate prepare s;
prepare s from 'select distinct percentile_cont(0.5) within group (order by ?) over (), percentile_disc(0.5) within group (order by ?) over () from tdist';
execute s using @v, @v;
deallocate prepare s;
prepare s from 'select a % 3 as g, percentile_cont(0.5) within group (order by ?) from tdist group by a % 3 order by 1';
execute s using @v;
deallocate prepare s;


evaluate 'Case 12: a CHAR bind of MEDIAN and PERCENTILE_CONT casts to DOUBLE; a DATE bound directly keeps DATE, the aggregate part as an unchanged control';
set @v = cast('10' as char(2));
select typeof(@v) as bind_type, @v as bind_value;
prepare s from 'select median(?), median(distinct ?), percentile_cont(0.5) within group (order by ?) from tdist';
execute s using @v, @v, @v;
deallocate prepare s;
-- a DATE literal in EXECUTE USING binds a DATE; the aggregate MEDIAN of a DATE already returned DATE before the fix
prepare s from 'select median(?), typeof(median(?)), percentile_cont(0.5) within group (order by ?), typeof(percentile_cont(0.5) within group (order by ?)) from tdist';
execute s using date'2024-01-01', date'2024-01-01', date'2024-01-01', date'2024-01-01';
deallocate prepare s;
prepare s from 'select distinct median(distinct ?) over (), typeof(median(distinct ?) over ()) from tdist';
execute s using date'2024-01-01', date'2024-01-01';
deallocate prepare s;


drop variable @v, @v1, @v2, @v3;
drop table tdist;
