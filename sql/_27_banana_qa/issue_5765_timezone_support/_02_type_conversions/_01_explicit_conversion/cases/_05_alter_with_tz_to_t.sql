--cast date/time columns with timezone to TIME(L)TZ types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(
	c timestamp with local time zone, 
	d timestamp with time zone,
	e datetime with local time zone,
	f datetime with time zone
);
set timezone '+3:00';
insert into tz_test values(timestamptz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro', datetime'2019-12-10 3:40:56.299', datetimetz' 2019-12-10 3:40:56.299 Indian/Comoro');
commit;

set system parameters 'alter_table_change_type_strict=no';

set timezone 'Pacific/Saipan';
--test: cast date/time columns with timezone to TIME types
--BUG: CUBRIDSUS-16998, resolved
alter table tz_test modify c time;
alter table tz_test modify d time;
alter table tz_test modify e time;
alter table tz_test modify f time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast date/time columns with timezone to TIMELTZ types
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;
alter table tz_test modify e datetime with local time zone;
alter table tz_test modify f datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast date/time columns with timezone to TIMETZ types
--BUG: CUBRIDSUS-17326
--BUG: CUBRIDSUS-16974, resolved
alter table tz_test modify c datetime with time zone;
alter table tz_test modify d datetime with time zone;
alter table tz_test modify e datetime with time zone;
alter table tz_test modify f datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';

autocommit on;
