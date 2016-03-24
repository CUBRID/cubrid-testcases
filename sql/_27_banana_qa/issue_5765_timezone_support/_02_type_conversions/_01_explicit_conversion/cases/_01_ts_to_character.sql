--cast TIMESTAMP(L)TZ columns to character string/enum data types


drop table if exists tz_test;

create table tz_test(id int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

--test: cast ts column to character string types
select id, cast(ts as char(20)) from tz_test order by 1;
select id, cast(ts as char(40)) from tz_test order by 1;
select id, cast(ts as varchar(20)) from tz_test order by 1;
select id, cast(ts as varchar(40)) from tz_test order by 1;
select id, cast(ts as varchar) from tz_test order by 1;
select id, cast(ts as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(ts as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(ts as enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 UTC')) from tz_test where id=1 order by 1;

--test: cast tsltz column to character string types
select id, cast(tsltz as char(20)) from tz_test order by 1;
select id, cast(tsltz as char(40)) from tz_test order by 1;
select id, cast(tsltz as varchar(20)) from tz_test order by 1;
select id, cast(tsltz as varchar(40)) from tz_test order by 1;
select id, cast(tsltz as varchar) from tz_test order by 1;
select id, cast(tsltz as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(tsltz as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(tsltz as enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 UTC UTC')) from tz_test where id=1 order by 1;

--test: cast tstz column to character string types
select id, cast(tstz as char(20)) from tz_test order by 1;
select id, cast(tstz as char(40)) from tz_test order by 1;
select id, cast(tstz as varchar(20)) from tz_test order by 1;
select id, cast(tstz as varchar(40)) from tz_test order by 1;
select id, cast(tstz as varchar) from tz_test order by 1;
select id, cast(tstz as string) from tz_test order by 1;
--test: cast ts column to enum type
select id, cast(tstz as enum('a', 'b', 'c')) from tz_test order by 1;
select id, cast(tstz as enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 UTC UTC')) from tz_test where id=1 order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
