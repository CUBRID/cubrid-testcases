--cast date/time columns to TIME(L)TZ types


drop table if exists tz_test;

create table tz_test(a date, b time, c timestamp, d datetime);
insert into tz_test values(date'2000-10-10', time'12:13:14', timestamp'2000-10-10 3:40:56', datetime'2000-10-10 3:40:56.299');

--test: cast date/time columns to TIME types
select cast(a as time) from tz_test;
select cast(b as time) from tz_test;
select cast(c as time) from tz_test;
select cast(d as time) from tz_test;

set timezone '-8:00';
--test: cast date/time columns to TIMELTZ types
select cast(a as datetime with local time zone) from tz_test;
select cast(b as datetime with local time zone) from tz_test;
select cast(c as datetime with local time zone) from tz_test;
select cast(d as datetime with local time zone) from tz_test;

--test: cast date/time columns to TIMETZ types
select cast(a as datetime with time zone) from tz_test;
select cast(b as datetime with time zone) from tz_test;
select cast(c as datetime with time zone) from tz_test;
select cast(d as datetime with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
