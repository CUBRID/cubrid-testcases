--cast date/time columns to DATETIME(L)TZ types


drop table if exists tz_test;

create table tz_test(a date, b time, c datetime, d datetime);
insert into tz_test values(date'2000-10-10', time'12:13:14', datetime'2019-12-10 3:40:56.999', datetime'2019-12-10 3:40:56.999');

--test: cast date/time columns to DATETIME types
select cast(a as datetime) from tz_test;
select cast(b as datetime) from tz_test;
select cast(c as datetime) from tz_test;
select cast(d as datetime) from tz_test;

--test: cast date/time columns to DATETIMELTZ types
select cast(a as datetime with local time zone) from tz_test;
select cast(b as datetime with local time zone) from tz_test;
select cast(c as datetime with local time zone) from tz_test;
select cast(d as datetime with local time zone) from tz_test;

--test: cast date/time columns to DATETIMETZ types
select cast(a as datetime with time zone) from tz_test;
select cast(b as datetime with time zone) from tz_test;
select cast(c as datetime with time zone) from tz_test;
select cast(d as datetime with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
