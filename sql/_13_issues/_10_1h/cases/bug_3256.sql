-- second argument is numeric
select case when ifnull(date'2010-01-01', 0) = cast(date'2010-01-01' as varchar(64)) then 'OK' else 'NOK' end;
select case when ifnull(time'09:30:30', 0) = cast(time'09:30:30' as varchar(64)) then 'OK' else 'NOK' end;
select case when ifnull(datetime'2010-01-01 09:30:30.001', 0) = cast(datetime'2010-01-01 09:30:30.001' as varchar(64)) then 'OK' else 'NOK' end;
select case when ifnull(timestamp'2010-01-01 09:30:30', 0) = cast(timestamp'2010-01-01 09:30:30' as varchar(64)) then 'OK' else 'NOK' end;

-- second argument is string
select case when ifnull(date'2010-01-01', 'a') = cast(date'2010-01-01' as varchar(64)) then 'OK' else 'NOK' end;
select case when ifnull(time'09:30:30', 'a') = cast(time'09:30:30' as varchar(64)) then 'OK' else 'NOK' end;
select case when ifnull(datetime'2010-01-01 09:30:30.001', 'a') = cast(datetime'2010-01-01 09:30:30.001' as varchar(64)) then 'OK' else 'NOK' end;
select case when ifnull(timestamp'2010-01-01 09:30:30', 'a') = cast(timestamp'2010-01-01 09:30:30' as varchar(64)) then 'OK' else 'NOK' end;

-- first argument is numeric, but it returns STRING '0'
select case when ifnull(0, date'2010-01-01') = '0' then 'OK' else 'NOK' end;
select case when ifnull(0, time'09:30:30')  = '0' then 'OK' else 'NOK' end;
select case when ifnull(0, datetime'2010-01-01 09:30:30.001')  = '0' then 'OK' else 'NOK' end;
select case when ifnull(0, timestamp'2010-01-01 09:30:30')  = '0' then 'OK' else 'NOK' end;

-- first argument is string
select case when ifnull('a', date'2010-01-01') = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', time'09:30:30')  = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', datetime'2010-01-01 09:30:30.001')  = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', timestamp'2010-01-01 09:30:30')  = 'a' then 'OK' else 'NOK' end;


-- should return INTEGER 0
select case when ifnull(cast(NULL as date), 0) = 0 then 'OK' else 'NOK' end;
select case when ifnull(cast(NULL as time), 0) = 0 then 'OK' else 'NOK' end;
select case when ifnull(cast(NULL as datetime), 0) = 0 then 'OK' else 'NOK' end;
select case when ifnull(cast(NULL as timestamp), 0) = 0 then 'OK' else 'NOK' end;

-- should return STRING '0'
select case when ifnull(cast(NULL as date), '0') = '0'then 'OK' else 'NOK' end;
select case when ifnull(cast(NULL as time), '0') = '0'then 'OK' else 'NOK' end;
select case when ifnull(cast(NULL as datetime), '0') = '0'then 'OK' else 'NOK' end;
select case when ifnull(cast(NULL as timestamp), '0') = '0'then 'OK' else 'NOK' end;


prepare stmt1 from 'select ifnull(?, 1)';
execute stmt1 using date'2010-01-01';
execute stmt1 using time'09:30:30';
execute stmt1 using datetime'2010-01-01 09:30:30.001';
execute stmt1 using timestamp'2010-01-01 09:30:30';
deallocate prepare stmt1;

prepare stmt1 from 'select ifnull(?, ?)';
execute stmt1 using date'2010-01-01', 1;
execute stmt1 using time'09:30:30', 1;
execute stmt1 using datetime'2010-01-01 09:30:30.001', 1;
execute stmt1 using timestamp'2010-01-01 09:30:30', 1;
deallocate prepare stmt1;

prepare stmt1 from 'select ifnull(?, ?)';
execute stmt1 using date'2010-01-01', 'a';
execute stmt1 using time'09:30:30', 'a';
execute stmt1 using datetime'2010-01-01 09:30:30.001', 'a';
execute stmt1 using timestamp'2010-01-01 09:30:30', 'a';
deallocate prepare stmt1;



create table x (d date, t time, dt datetime, ts timestamp, i int, vc varchar(32));
insert into x values(date'2010-01-01', time'09:30:30', datetime'2010-01-01 09:30:30.001', timestamp'2010-01-01 09:30:30', 1, 'non-null');
insert into x values(NULL, NULL, NULL, NULL, 0, 'null');

-- first argument is not null
select case when ifnull(d, i) = cast(d as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;
select case when ifnull(t, i) = cast(t as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;
select case when ifnull(dt, i) = cast(dt as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;
select case when ifnull(ts, i) = cast(ts as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;

select case when ifnull(d, vc) = cast(d as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;
select case when ifnull(t, vc) = cast(t as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;
select case when ifnull(dt, vc) = cast(dt as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;
select case when ifnull(ts, vc) = cast(ts as varchar(64)) then 'OK' else 'NOK' end from x where i = 1;

-- first argument is null
select case when ifnull(d, i) = cast(i as varchar(32)) then 'OK' else 'NOK' end from x where i = 0;
select case when ifnull(t, i) = cast(i as varchar(32)) then 'OK' else 'NOK' end from x where i = 0;
select case when ifnull(dt, i) = cast(i as varchar(32)) then 'OK' else 'NOK' end from x where i = 0;
select case when ifnull(ts, i) = cast(i as varchar(32)) then 'OK' else 'NOK' end from x where i = 0;


select case when ifnull(d, vc) = vc then 'OK' else 'NOK' end from x where i = 0;
select case when ifnull(t, vc) = vc then 'OK' else 'NOK' end from x where i = 0;
select case when ifnull(dt, vc) = vc then 'OK' else 'NOK' end from x where i = 0;
select case when ifnull(ts, vc) = vc then 'OK' else 'NOK' end from x where i = 0;

drop table x;


select case when ifnull(null, null) is null then 'OK' else 'NOK' end;
select case when ifnull(null, cast(0 as integer)) = cast(0 as integer) then 'OK' else 'NOK' end;
select case when ifnull('a', null) = 'a' then 'OK' else 'NOK' end;

prepare stmt1 from 'select case when ifnull(null, ?) = ? then ''OK'' else ''NOK'' end';
execute stmt1 using date'2010-01-01', date'2010-01-01';
execute stmt1 using time'09:30:30', time'09:30:30';
execute stmt1 using datetime'2010-01-01 09:30:30.001', datetime'2010-01-01 09:30:30.001';
execute stmt1 using timestamp'2010-01-01 09:30:30', timestamp'2010-01-01 09:30:30';
deallocate prepare stmt1;

select case when ifnull('a', cast(1 as bigint)) = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', cast(1 as integer)) = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', cast(1 as short)) = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', cast(1.1 as numeric(10,5))) = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', cast(1.1 as double)) = 'a' then 'OK' else 'NOK' end;
select case when ifnull('a', cast(1.1 as float)) = 'a' then 'OK' else 'NOK' end;

select case when ifnull(cast(1.1 as numeric(10,5)), cast(1.1 as double)) = cast(1.1 as numeric(10,5)) then 'OK' else 'NOK' end;
select case when ifnull(cast(1.1 as double), cast(1.1 as float)) = cast(1.1 as double) then 'OK' else 'NOK' end;
select case when ifnull(cast(1.1 as float), cast(1 as bigint)) = cast(1.1 as float) then 'OK' else 'NOK' end;
select case when ifnull(cast(9223372036854775807 as bigint), cast(1 as integer)) = cast(9223372036854775807 as bigint) then 'OK' else 'NOK' end;
select case when ifnull(cast(2147483647 as integer), cast(1 as short)) = cast(2147483647 as integer) then 'OK' else 'NOK' end;




