--cast DATETIME(L)TZ columns to collection data types


drop table if exists tz_test;

create table tz_test(id int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: cast ts column to collection types
select id, cast(ts as set(datetime)) from tz_test order by 1;
select id, cast(ts as multiset(datetime with local time zone)) from tz_test order by 1;
select id, cast(ts as list(datetime)) from tz_test order by 1;
select id, cast(ts as sequence(datetime with time zone)) from tz_test order by 1;

--test: cast dtltz column to collection types
select id, cast(dtltz as set(datetime)) from tz_test order by 1;
select id, cast(dtltz as multiset(datetime with local time zone)) from tz_test order by 1;
select id, cast(dtltz as list(datetime)) from tz_test order by 1;
select id, cast(dtltz as sequence(datetime with time zone)) from tz_test order by 1;

--test: cast dttz column to collection types
select id, cast(dttz as set(datetime)) from tz_test order by 1;
select id, cast(dttz as multiset(datetime with local time zone)) from tz_test order by 1;
select id, cast(dttz as list(datetime)) from tz_test order by 1;
select id, cast(dttz as sequence(datetime with time zone)) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
