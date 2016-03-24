--cast TIME(L)TZ columns to collection data types


drop table if exists tz_test;

create table tz_test(id int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: cast ts column to collection types
select id, cast(ts as set(time)) from tz_test order by 1;
select id, cast(ts as multiset(datetime with local time zone)) from tz_test order by 1;
select id, cast(ts as list(time)) from tz_test order by 1;
select id, cast(ts as sequence(datetime with time zone)) from tz_test order by 1;

--test: cast tltz column to collection types
select id, cast(tltz as set(time)) from tz_test order by 1;
select id, cast(tltz as multiset(datetime with local time zone)) from tz_test order by 1;
select id, cast(tltz as list(time)) from tz_test order by 1;
select id, cast(tltz as sequence(datetime with time zone)) from tz_test order by 1;

--test: cast ttz column to collection types
select id, cast(ttz as set(time)) from tz_test order by 1;
select id, cast(ttz as multiset(datetime with local time zone)) from tz_test order by 1;
select id, cast(ttz as list(time)) from tz_test order by 1;
select id, cast(ttz as sequence(datetime with time zone)) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
