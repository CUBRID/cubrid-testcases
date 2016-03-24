--cast TIMESTAMP(L)TZ columns to date/time types


drop table if exists tz_test;

create table tz_test(id int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

--test: cast ts column to date/time types
select id, cast(ts as date) from tz_test order by 1;
select id, cast(ts as time) from tz_test order by 1;
select id, cast(ts as timestamp) from tz_test order by 1;
select id, cast(ts as datetime) from tz_test order by 1;

--test: cast tsltz column to date/time types
select id, cast(tsltz as date) from tz_test order by 1;
select id, cast(tsltz as time) from tz_test order by 1;
select id, cast(tsltz as timestamp) from tz_test order by 1;
select id, cast(tsltz as datetime) from tz_test order by 1;

--test: cast tstz column to date/time types
select id, cast(tstz as date) from tz_test order by 1;
select id, cast(tstz as time) from tz_test order by 1;
select id, cast(tstz as timestamp) from tz_test order by 1;
select id, cast(tstz as datetime) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
