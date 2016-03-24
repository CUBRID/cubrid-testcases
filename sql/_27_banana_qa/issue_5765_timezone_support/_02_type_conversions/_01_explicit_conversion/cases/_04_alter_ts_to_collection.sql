--cast TIMESTAMP(L)TZ columns to collection data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo');

--test: [er] cast ts column to collection types
alter table tz_test modify ts set timestamp;
alter table tz_test modify ts multiset timestamp with local time zone;
alter table tz_test modify ts sequence timestamp with time zone;
select * from tz_test order by 1;

--test: [er] cast tsltz column to collection types
alter table tz_test modify tsltz set timestamp;
alter table tz_test modify tsltz multiset timestamp with local time zone;
alter table tz_test modify tsltz sequence timestamp with time zone;
select * from tz_test order by 1;

--test: [er] cast tstz column to collection types
alter table tz_test modify tstz set timestamp;
alter table tz_test modify tstz multiset timestamp with local time zone;
alter table tz_test modify tstz sequence timestamp with time zone;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
