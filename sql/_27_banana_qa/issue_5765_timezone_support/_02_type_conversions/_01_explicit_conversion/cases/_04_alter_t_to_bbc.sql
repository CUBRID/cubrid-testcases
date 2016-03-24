--cast TIME(L)TZ columns to bit/blob/clob data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, t time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: [er] cast t column to bit/blob/clob types
alter table tz_test modify t bit(20);
alter table tz_test modify t bit varying(10);
alter table tz_test modify t blob;
alter table tz_test modify t clob;
select * from tz_test order by 1;

--test: [er] cast tltz column to bit/blob/clob types
alter table tz_test modify tltz bit(20);
alter table tz_test modify tltz bit varying(10);
alter table tz_test modify tltz blob;
alter table tz_test modify tltz clob;
select * from tz_test order by 1;

--test: [er] cast ttz column to bit/blob/clob types
alter table tz_test modify ttz bit(20);
alter table tz_test modify ttz bit varying(10);
alter table tz_test modify ttz blob;
alter table tz_test modify ttz clob;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
