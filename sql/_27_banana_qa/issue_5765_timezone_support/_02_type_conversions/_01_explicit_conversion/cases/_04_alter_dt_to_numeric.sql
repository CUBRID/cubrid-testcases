--cast DATETIME(L)TZ columns to numeric data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: [er] cast ts column to numeric types
alter table tz_test change ts ts short;
alter table tz_test change ts ts int;
alter table tz_test change ts ts bigint;
alter table tz_test change ts ts numeric(6, 2);
alter table tz_test change ts ts float;
alter table tz_test change ts ts double;
select * from tz_test order by 1;

--test: [er] cast dtltz column to numeric types
alter table tz_test change dtltz dtltz short;
alter table tz_test change dtltz dtltz int;
alter table tz_test change dtltz dtltz bigint;
alter table tz_test change dtltz dtltz numeric(6, 2);
alter table tz_test change dtltz dtltz float;
alter table tz_test change dtltz dtltz double;
select * from tz_test order by 1;

--test: [er] cast dttz column to numeric types
alter table tz_test change dttz dttz short;
alter table tz_test change dttz dttz int;
alter table tz_test change dttz dttz bigint;
alter table tz_test change dttz dttz numeric(6, 2);
alter table tz_test change dttz dttz float;
alter table tz_test change dttz dttz double;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
