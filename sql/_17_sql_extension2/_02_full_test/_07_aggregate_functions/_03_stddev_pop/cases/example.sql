--cases from dev

create table test_table (d double);
insert into test_table values(78), (63.65), (230.54), (32), (17.2), (195.7689), (57.57);
select stddev_pop(d) from test_table;
select stddev_pop(power(d,2)+d*2+1) from test_table;
select stddev_pop(d) from test_table;
drop table test_table;


create table t (i int, d double);
insert into t values(78, 78), (63, 63), (54, 54), (32, 32), (72, 72), (19, 19), (57, 57);

select stddev_pop(i), stddev_pop(d), if(abs(stddev_pop(i) - stddev_pop(d)) < 0.5, 'ok', 'nok') from t;
select stddev_pop(i+1), stddev_pop(d+1), if(abs(stddev_pop(i+1) - stddev_pop(d+1)) < 0.5, 'ok', 'nok') from t;
select stddev_pop(i-1), stddev_pop(d-1), if(abs(stddev_pop(i-1) - stddev_pop(d-1)) < 0.5, 'ok', 'nok') from t;
select stddev_pop(i*2), stddev_pop(d*2), if(abs(stddev_pop(i*2) - stddev_pop(d*2)) < 0.5, 'ok', 'nok') from t;

-- for the following query the result of stddev_pop(i/2)-stddev_pop(d/2) can not be predicted because the input args of stddev_pop are different
-- (the argument i/2 is rounded, so it is different from d/2 for 63, 19, and 57)
-- select stddev_pop(i/2), stddev_pop(d/2), if(abs(stddev_pop(i/2) - stddev_pop(d/2)) < 0.1, 'ok', 'nok') from t;

select stddev_pop(power(i,2)), stddev_pop(power(d,2)), if(abs(stddev_pop(power(i,2)) - stddev_pop(power(d,2))) < 0.1, 'ok', 'nok') from t;
select stddev_pop(cast(i as short)), stddev_pop(d), if(abs(stddev_pop(cast(i as short)) - stddev_pop(d)) < 0.5, 'ok', 'nok') from t;
select stddev_pop(cast(i as bigint)), stddev_pop(d), if(abs(stddev_pop(cast(i as bigint)) - stddev_pop(d)) < 0.5, 'ok', 'nok') from t;

-- check if null is included
insert into t values(null, null);
select if(stddev_pop(i) is not null, 'ok', 'nok') from t;

-- check if table is empty
truncate t;
select if(stddev_pop(i) is null, 'ok', 'nok') from t;

-- check if table has only null tuples
insert into t values(null, null), (null, null), (null, null);
select if(stddev_pop(i) is null, 'ok', 'nok') from t;

drop table t;

