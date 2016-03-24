--cast TIME(L)TZ columns to numeric data types


drop table if exists tz_test;

create table tz_test(id int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: cast ts column to numeric types
select id, cast(ts as short) from tz_test order by 1;
select id, cast(ts as int) from tz_test order by 1;
select id, cast(ts as bigint) from tz_test order by 1;
select id, cast(ts as numeric(6, 2)) from tz_test order by 1;
select id, cast(ts as float) from tz_test order by 1;
select id, cast(ts as double) from tz_test order by 1;

--test: cast tltz column to numeric types
select id, cast(tltz as short) from tz_test order by 1;
select id, cast(tltz as int) from tz_test order by 1;
select id, cast(tltz as bigint) from tz_test order by 1;
select id, cast(tltz as numeric(6, 2)) from tz_test order by 1;
select id, cast(tltz as float) from tz_test order by 1;
select id, cast(tltz as double) from tz_test order by 1;

--test: cast ttz column to numeric types
select id, cast(ttz as short) from tz_test order by 1;
select id, cast(ttz as int) from tz_test order by 1;
select id, cast(ttz as bigint) from tz_test order by 1;
select id, cast(ttz as numeric(6, 2)) from tz_test order by 1;
select id, cast(ttz as float) from tz_test order by 1;
select id, cast(ttz as double) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
