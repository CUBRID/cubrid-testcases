--cast date/time columns with timezone to TIME(L)TZ types


drop table if exists tz_test;

create table tz_test(
	c timestamp with local time zone, 
	d timestamp with time zone,
	e datetime with local time zone,
	f datetime with time zone
);
set timezone '+3:00';
insert into tz_test values(timestamptz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro', datetimetz' 2019-12-10 3:40:56.299', datetimetz' 2019-12-10 3:40:56.299 Indian/Comoro');

set timezone 'UTC';
--test: cast date/time columns with timezone to TIME types
select cast(c as time) from tz_test;
select cast(d as time) from tz_test;
select cast(e as time) from tz_test;
select cast(f as time) from tz_test;

set timezone '+9:00';
--test: cast date/time columns with timezone to TIMELTZ types
select cast(c as datetime with local time zone) from tz_test;
select cast(d as datetime with local time zone) from tz_test;
select cast(e as datetime with local time zone) from tz_test;
select cast(f as datetime with local time zone) from tz_test;

--test: cast date/time columns with timezone to TIMETZ types
select cast(c as datetime with time zone) from tz_test;
select cast(d as datetime with time zone) from tz_test;
select cast(e as datetime with time zone) from tz_test;
select cast(f as datetime with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
