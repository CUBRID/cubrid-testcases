--cast date/time columns to TIMESTAMP(L)TZ types


drop table if exists tz_test;

create table tz_test(a date, b time, c timestamp, d datetime);
insert into tz_test values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.299');

--test: cast date/time columns to TIMESTAMP types
select cast(a as timestamp) from tz_test;
select cast(b as timestamp) from tz_test;
select cast(c as timestamp) from tz_test;
select cast(d as timestamp) from tz_test;

--test: cast date/time columns to TIMESTAMPLTZ types
select cast(a as timestamp with local time zone) from tz_test;
select cast(b as timestamp with local time zone) from tz_test;
select cast(c as timestamp with local time zone) from tz_test;
select cast(d as timestamp with local time zone) from tz_test;

--test: cast date/time columns to TIMESTAMPTZ types
select cast(a as timestamp with time zone) from tz_test;
select cast(b as timestamp with time zone) from tz_test;
select cast(c as timestamp with time zone) from tz_test;
select cast(d as timestamp with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
