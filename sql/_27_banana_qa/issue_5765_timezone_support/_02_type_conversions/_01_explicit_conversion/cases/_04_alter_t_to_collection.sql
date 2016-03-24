--cast TIME(L)TZ columns to collection data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, t time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: [er] cast t column to collection types
alter table tz_test modify t set time;
alter table tz_test modify t multiset datetime with local time zone;
alter table tz_test modify t sequence datetime with time zone;
select * from tz_test order by 1;

--test: [er] cast tltz column to collection types
alter table tz_test modify tltz set time;
alter table tz_test modify tltz multiset datetime with local time zone;
alter table tz_test modify tltz sequence datetime with time zone;
select * from tz_test order by 1;

--test: [er] cast ttz column to collection types
alter table tz_test modify ttz set time;
alter table tz_test modify ttz multiset datetime with local time zone;
alter table tz_test modify ttz sequence datetime with time zone;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
