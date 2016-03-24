--cast TIME(L)TZ columns to numeric data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: [er] cast ts column to numeric types
alter table tz_test change ts ts short;
alter table tz_test change ts ts int;
alter table tz_test change ts ts bigint;
alter table tz_test change ts ts numeric(6, 2);
alter table tz_test change ts ts float;
alter table tz_test change ts ts double;
select * from tz_test order by 1;

--test: [er] cast tltz column to numeric types
alter table tz_test change tltz tltz short;
alter table tz_test change tltz tltz int;
alter table tz_test change tltz tltz bigint;
alter table tz_test change tltz tltz numeric(6, 2);
alter table tz_test change tltz tltz float;
alter table tz_test change tltz tltz double;
select * from tz_test order by 1;

--test: [er] cast ttz column to numeric types
alter table tz_test change ttz ttz short;
alter table tz_test change ttz ttz int;
alter table tz_test change ttz ttz bigint;
alter table tz_test change ttz ttz numeric(6, 2);
alter table tz_test change ttz ttz float;
alter table tz_test change ttz ttz double;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
