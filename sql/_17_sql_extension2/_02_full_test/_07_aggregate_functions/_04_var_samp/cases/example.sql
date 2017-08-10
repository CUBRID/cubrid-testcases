--cases from dev


create table test_table (d double);
insert into test_table values(78), (63.65), (230.54), (32), (17.2), (195.7689), (57.57);
select var_samp(d) from test_table;
select var_samp(power(d,2)+d*2+1) from test_table;
truncate table test_table;
select var_samp(d) from test_table;
drop table test_table;


create table t (i int, d double);
insert into t values(78, 78), (63, 63), (54, 54), (32, 32), (72, 72), (19, 19), (57, 57);

select var_samp(i), var_samp(d), if(abs(var_samp(i) - var_samp(d)) < 0.1, 'ok', 'nok') from t;
select var_samp(i+1), var_samp(d+1), if(abs(var_samp(i+1) - var_samp(d+1)) < 0.1, 'ok', 'nok') from t;
select var_samp(i-1), var_samp(d-1), if(abs(var_samp(i-1) - var_samp(d-1)) < 0.1, 'ok', 'nok') from t;
select var_samp(i*2), var_samp(d*2), if(abs(var_samp(i*2) - var_samp(d*2)) < 0.1, 'ok', 'nok') from t;
select var_samp(i/2), var_samp(d/2), if(abs(var_samp(i/2) - var_samp(d/2)) < 0.1, 'ok', 'nok') from t;
select var_samp(power(i,2)), var_samp(power(d,2)), if(abs(var_samp(power(i,2)) - var_samp(power(d,2))) < 0.1, 'ok', 'nok') from t;
select var_samp(cast(i as short)), var_samp(d), if(abs(var_samp(cast(i as short)) - var_samp(d)) < 0.1, 'ok', 'nok') from t;
select var_samp(cast(i as bigint)), var_samp(d), if(abs(var_samp(cast(i as bigint)) - var_samp(d)) < 0.1, 'ok', 'nok') from t;

-- check if null is included
insert into t values(null, null);
select if(var_samp(i) is not null, 'ok', 'nok') from t;

-- check if table is empty
truncate t;
select if(var_samp(i) is null, 'ok', 'nok') from t;

-- check if table has only null tuples
insert into t values(null, null), (null, null), (null, null);
select if(var_samp(i) is null, 'ok', 'nok') from t;

drop table t;

