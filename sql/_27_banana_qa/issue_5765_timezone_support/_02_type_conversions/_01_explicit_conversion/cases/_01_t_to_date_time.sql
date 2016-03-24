--cast TIME(L)TZ columns to date/time types


drop table if exists tz_test;

create table tz_test(id int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: cast ts column to date/time types
select id, cast(ts as date) from tz_test order by 1;
select id, cast(ts as time) from tz_test order by 1;
select id, cast(ts as timestamp) from tz_test order by 1;
select id, cast(ts as datetime) from tz_test order by 1;

--test: cast tltz column to date/time types
select id, cast(tltz as date) from tz_test order by 1;
select id, cast(tltz as time) from tz_test order by 1;
select id, cast(tltz as timestamp) from tz_test order by 1;
select id, cast(tltz as datetime) from tz_test order by 1;

--test: cast ttz column to date/time types
select id, cast(ttz as date) from tz_test order by 1;
select id, cast(ttz as time) from tz_test order by 1;
select id, cast(ttz as timestamp) from tz_test order by 1;
select id, cast(ttz as datetime) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
