--cast DATETIME(L)TZ columns to numeric data types


drop table if exists tz_test;

create table tz_test(id int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: cast ts column to numeric types
select id, cast(ts as short) from tz_test order by 1;
select id, cast(ts as int) from tz_test order by 1;
select id, cast(ts as bigint) from tz_test order by 1;
select id, cast(ts as numeric(6, 2)) from tz_test order by 1;
select id, cast(ts as float) from tz_test order by 1;
select id, cast(ts as double) from tz_test order by 1;

--test: cast dtltz column to numeric types
select id, cast(dtltz as short) from tz_test order by 1;
select id, cast(dtltz as int) from tz_test order by 1;
select id, cast(dtltz as bigint) from tz_test order by 1;
select id, cast(dtltz as numeric(6, 2)) from tz_test order by 1;
select id, cast(dtltz as float) from tz_test order by 1;
select id, cast(dtltz as double) from tz_test order by 1;

--test: cast dttz column to numeric types
select id, cast(dttz as short) from tz_test order by 1;
select id, cast(dttz as int) from tz_test order by 1;
select id, cast(dttz as bigint) from tz_test order by 1;
select id, cast(dttz as numeric(6, 2)) from tz_test order by 1;
select id, cast(dttz as float) from tz_test order by 1;
select id, cast(dttz as double) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
