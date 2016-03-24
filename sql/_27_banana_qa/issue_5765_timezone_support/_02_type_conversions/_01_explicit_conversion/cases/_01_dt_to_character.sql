--cast DATETIME(L)TZ columns to character string/enum data types


drop table if exists tz_test;

create table tz_test(id int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: cast ts column to character string types
select id, cast(ts as char(20)) from tz_test order by 1;
select id, cast(ts as char(40)) from tz_test order by 1;
select id, cast(ts as varchar(20)) from tz_test order by 1;
select id, cast(ts as varchar(40)) from tz_test order by 1;
select id, cast(ts as varchar) from tz_test order by 1;
select id, cast(ts as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(ts as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(ts as enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 UTC')) from tz_test where id=1 order by 1;

--test: cast dtltz column to character string types
select id, cast(dtltz as char(20)) from tz_test order by 1;
select id, cast(dtltz as char(40)) from tz_test order by 1;
select id, cast(dtltz as varchar(20)) from tz_test order by 1;
select id, cast(dtltz as varchar(40)) from tz_test order by 1;
select id, cast(dtltz as varchar) from tz_test order by 1;
select id, cast(dtltz as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(dtltz as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(dtltz as enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 UTC UTC')) from tz_test where id=1 order by 1;

--test: cast dttz column to character string types
select id, cast(dttz as char(20)) from tz_test order by 1;
select id, cast(dttz as char(50)) from tz_test order by 1;
select id, cast(dttz as varchar(20)) from tz_test order by 1;
select id, cast(dttz as varchar(50)) from tz_test order by 1;
select id, cast(dttz as varchar) from tz_test order by 1;
select id, cast(dttz as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(dttz as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(dttz as enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 UTC UTC')) from tz_test where id=1 order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
