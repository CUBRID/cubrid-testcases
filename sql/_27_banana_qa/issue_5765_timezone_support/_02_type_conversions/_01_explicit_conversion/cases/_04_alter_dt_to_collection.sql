--cast DATETIME(L)TZ columns to collection data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: [er] cast ts column to collection types
alter table tz_test modify ts set datetime;
alter table tz_test modify ts multiset datetime with local time zone;
alter table tz_test modify ts sequence datetime with time zone;
select * from tz_test order by 1;

--test: [er] cast dtltz column to collection types
alter table tz_test modify dtltz set datetime;
alter table tz_test modify dtltz multiset datetime with local time zone;
alter table tz_test modify dtltz sequence datetime with time zone;
select * from tz_test order by 1;

--test: [er] cast dttz column to collection types
alter table tz_test modify dttz set datetime;
alter table tz_test modify dttz multiset datetime with local time zone;
alter table tz_test modify dttz sequence datetime with time zone;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
