--cast TIME(L)TZ columns to character string/enum data types


drop table if exists tz_test;

create table tz_test(id int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: cast ts column to character string types
select id, cast(ts as char(40)) from tz_test order by 1;
select id, cast(ts as char(40)) from tz_test order by 1;
select id, cast(ts as varchar(40)) from tz_test order by 1;
select id, cast(ts as varchar(40)) from tz_test order by 1;
select id, cast(ts as varchar) from tz_test order by 1;
select id, cast(ts as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(ts as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(ts as enum('12:00:01 PM', '2015-9-17 12:00:01 PM +08:00', '2015-9-17 12:00:01 PM -10:00', '2015-9-17 12:00:01 PM Asia/Tokyo', '2015-9-17 12:00:01 PM +00:00')) from tz_test where id=1 order by 1;

--test: cast tltz column to character string types
select id, cast(tltz as char(40)) from tz_test order by 1;
select id, cast(tltz as char(40)) from tz_test order by 1;
select id, cast(tltz as varchar(40)) from tz_test order by 1;
select id, cast(tltz as varchar(40)) from tz_test order by 1;
select id, cast(tltz as varchar) from tz_test order by 1;
select id, cast(tltz as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(tltz as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(tltz as enum('12:00:01 PM', '2015-9-17 12:00:01 PM +08:00', '2015-9-17 12:00:01 PM -10:00', '2015-9-17 12:00:01 PM Asia/Tokyo', '2015-9-17 12:00:01 PM +00:00')) from tz_test where id=1 order by 1;

--test: cast ttz column to character string types
select id, cast(ttz as char(50)) from tz_test order by 1;
select id, cast(ttz as char(50)) from tz_test order by 1;
select id, cast(ttz as varchar(50)) from tz_test order by 1;
select id, cast(ttz as varchar(50)) from tz_test order by 1;
select id, cast(ttz as varchar) from tz_test order by 1;
select id, cast(ttz as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(ttz as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(ttz as enum('12:00:01 PM', '2015-9-17 12:00:01 PM +08:00', '2015-9-17 12:00:01 PM -10:00', '2015-9-17 12:00:01 PM Asia/Tokyo', '2015-9-17 12:00:01 PM +00:00')) from tz_test where id=1 order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
