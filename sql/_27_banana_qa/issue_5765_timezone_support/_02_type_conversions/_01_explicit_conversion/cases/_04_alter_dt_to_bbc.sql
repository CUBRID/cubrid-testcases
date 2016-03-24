--cast DATETIME(L)TZ columns to bit/blob/clob data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: [er] cast ts column to bit/blob/clob types
alter table tz_test modify ts bit(20);
alter table tz_test modify ts bit varying(10);
alter table tz_test modify ts blob;
alter table tz_test modify ts clob;
select * from tz_test order by 1;

--test: [er] cast dtltz column to bit/blob/clob types
alter table tz_test modify dtltz bit(20);
alter table tz_test modify dtltz bit varying(10);
alter table tz_test modify dtltz blob;
alter table tz_test modify dtltz clob;
select * from tz_test order by 1;

--test: [er] cast dttz column to bit/blob/clob types
alter table tz_test modify dttz bit(20);
alter table tz_test modify dttz bit varying(10);
alter table tz_test modify dttz blob;
alter table tz_test modify dttz clob;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
