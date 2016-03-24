--cast date/time columns with timezone to TIMESTAMP(L)TZ types


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
--test: cast date/time columns with timezone to TIMESTAMP types
select cast(c as timestamp) from tz_test;
select cast(d as timestamp) from tz_test;
select cast(e as timestamp) from tz_test;
select cast(f as timestamp) from tz_test;

set timezone 'Asia/Seoul';
--test: cast date/time columns with timezone to TIMESTAMPLTZ types
select cast(c as timestamp with local time zone) from tz_test;
select cast(d as timestamp with local time zone) from tz_test;
select cast(e as timestamp with local time zone) from tz_test;
select cast(f as timestamp with local time zone) from tz_test;

--test: cast date/time columns with timezone to TIMESTAMPTZ types
select cast(c as timestamp with time zone) from tz_test;
select cast(d as timestamp with time zone) from tz_test;
select cast(e as timestamp with time zone) from tz_test;
select cast(f as timestamp with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
