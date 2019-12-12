
create table agg_test (
int_col int,
smallint_col smallint,
float_col float,
double_col double,
numeric_col numeric(38,20),
varchar_col varchar(20));

insert into agg_test values (1, 1, 1, 1, 1, '1');
insert into agg_test values (3, 3, 3, 3, 3, '3');
insert into agg_test values (7, 7, 7, 7, 7, '7');
insert into agg_test values (2, 2, 2, 2, 2, '2');
insert into agg_test values (10, 10, 10, 10, 10, '10');
insert into agg_test values (4, 4, 4, 4, 4, '4');

-- check STDDEV and VARIANCE behavior - must be the same as STDDEV_POP and VAR_POP respectively

select if (stddev(int_col) = stddev_pop(int_col),'ok','nok') from agg_test;
select if (stddev(smallint_col) = stddev_pop(smallint_col),'ok','nok') from agg_test;
select if (stddev(float_col) = stddev_pop(float_col),'ok','nok') from agg_test;
select if (stddev(double_col) = stddev_pop(double_col),'ok','nok') from agg_test;
select if (stddev(numeric_col) = stddev_pop(numeric_col),'ok','nok') from agg_test;
select if (stddev(varchar_col) = stddev_pop(varchar_col),'ok','nok') from agg_test;

select if (variance(int_col) = var_pop(int_col),'ok','nok') from agg_test;
select if (variance(smallint_col) = var_pop(smallint_col),'ok','nok') from agg_test;
select if (variance(float_col) = var_pop(float_col),'ok','nok') from agg_test;
select if (variance(double_col) = var_pop(double_col),'ok','nok') from agg_test;
select if (variance(numeric_col) = var_pop(numeric_col),'ok','nok') from agg_test;
select if (variance(varchar_col) = var_pop(varchar_col),'ok','nok') from agg_test;

select if (stddev(int_col) <> stddev_samp(int_col),'ok','nok') from agg_test;
select if (stddev(smallint_col) <> stddev_samp(smallint_col),'ok','nok') from agg_test;
select if (stddev(float_col) <> stddev_samp(float_col),'ok','nok') from agg_test;
select if (stddev(double_col) <> stddev_samp(double_col),'ok','nok') from agg_test;
select if (stddev(numeric_col) <> stddev_samp(numeric_col),'ok','nok') from agg_test;
select if (stddev(varchar_col) <> stddev_samp(varchar_col),'ok','nok') from agg_test;

select if (variance(int_col) <> var_samp(int_col),'ok','nok') from agg_test;
select if (variance(smallint_col) <> var_samp(smallint_col),'ok','nok') from agg_test;
select if (variance(float_col) <> var_samp(float_col),'ok','nok') from agg_test;
select if (variance(double_col) <> var_samp(double_col),'ok','nok') from agg_test;
select if (variance(numeric_col) <> var_samp(numeric_col),'ok','nok') from agg_test;
select if (variance(varchar_col) <> var_samp(varchar_col),'ok','nok') from agg_test;

-- check return type

select if (stddev_pop(int_col) = stddev_pop(cast(int_col as double)),'ok','nok') from agg_test;
select if (stddev_pop(smallint_col) = stddev_pop(cast(smallint_col as double)),'ok','nok') from agg_test;
select if (stddev_pop(float_col) = stddev_pop(cast(float_col as double)),'ok','nok') from agg_test;
select if (stddev_pop(numeric_col) = stddev_pop(cast(numeric_col as double)),'ok','nok') from agg_test;
select if (stddev_pop(varchar_col) = stddev_pop(cast(varchar_col as double)),'ok','nok') from agg_test;

select if (stddev_samp(int_col) = stddev_samp(cast(int_col as double)),'ok','nok') from agg_test;
select if (stddev_samp(smallint_col) = stddev_samp(cast(smallint_col as double)),'ok','nok') from agg_test;
select if (stddev_samp(float_col) = stddev_samp(cast(float_col as double)),'ok','nok') from agg_test;
select if (stddev_samp(numeric_col) = stddev_samp(cast(numeric_col as double)),'ok','nok') from agg_test;
select if (stddev_samp(varchar_col) = stddev_samp(cast(varchar_col as double)),'ok','nok') from agg_test;

select if (var_pop(int_col) = var_pop(cast(int_col as double)),'ok','nok') from agg_test;
select if (var_pop(smallint_col) = var_pop(cast(smallint_col as double)),'ok','nok') from agg_test;
select if (var_pop(float_col) = var_pop(cast(float_col as double)),'ok','nok') from agg_test;
select if (var_pop(numeric_col) = var_pop(cast(numeric_col as double)),'ok','nok') from agg_test;
select if (var_pop(varchar_col) = var_pop(cast(varchar_col as double)),'ok','nok') from agg_test;

select if (var_samp(int_col) = var_samp(cast(int_col as double)),'ok','nok') from agg_test;
select if (var_samp(smallint_col) = var_samp(cast(smallint_col as double)),'ok','nok') from agg_test;
select if (var_samp(float_col) = var_samp(cast(float_col as double)),'ok','nok') from agg_test;
select if (var_samp(numeric_col) = var_samp(cast(numeric_col as double)),'ok','nok') from agg_test;
select if (var_samp(varchar_col) = var_samp(cast(varchar_col as double)),'ok','nok') from agg_test;

select if (avg(int_col) = avg(cast(int_col as double)),'ok','nok') from agg_test;
select if (avg(smallint_col) = avg(cast(smallint_col as double)),'ok','nok') from agg_test;
select if (avg(float_col) = avg(cast(float_col as double)),'ok','nok') from agg_test;
select if (avg(numeric_col) = avg(cast(numeric_col as double)),'ok','nok') from agg_test;
select if (avg(varchar_col) = avg(cast(varchar_col as double)),'ok','nok') from agg_test;

$int, $2, $int, $2
select if (avg(int_col + ?) = avg(cast((int_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (avg(smallint_col + ?) = avg(cast((smallint_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (avg(varchar_col + ?) = avg(cast((varchar_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (stddev_samp(int_col + ?) = stddev_samp(cast((int_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (stddev_samp(smallint_col + ?) = stddev_samp(cast((smallint_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (stddev_samp(varchar_col + ?) = stddev_samp(cast((varchar_col + ?) as double)),1,0) from agg_test;


$int, $2, $int, $2
select if (stddev_pop(int_col + ?) = stddev_pop(cast((int_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (stddev_pop(smallint_col + ?) = stddev_pop(cast((smallint_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (stddev_pop(varchar_col + ?) = stddev_pop(cast((varchar_col + ?) as double)),1,0) from agg_test;


$int, $2, $int, $2
select if (var_samp(int_col + ?) = var_samp(cast((int_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (var_samp(smallint_col + ?) = var_samp(cast((smallint_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (var_samp(varchar_col + ?) = var_samp(cast((varchar_col + ?) as double)),1,0) from agg_test;


$int, $2, $int, $2
select if (var_pop(int_col + ?) = var_pop(cast((int_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (var_pop(smallint_col + ?) = var_pop(cast((smallint_col + ?) as double)),1,0) from agg_test;

$int, $2, $int, $2
select if (var_pop(varchar_col + ?) = var_pop(cast((varchar_col + ?) as double)),1,0) from agg_test;

drop table agg_test;