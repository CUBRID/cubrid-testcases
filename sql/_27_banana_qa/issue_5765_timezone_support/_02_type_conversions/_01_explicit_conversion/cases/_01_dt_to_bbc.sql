--cast DATETIME(L)TZ columns to bit/lob data types


drop table if exists tz_test;

create table tz_test(id int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

--test: cast ts column to bit/blob/clob types
select id, cast(ts as bit(20)) from tz_test order by 1;
select id, cast(ts as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(ts as blob)) from tz_test order by 1;
select id, clob_to_char(cast(ts as clob)) from tz_test order by 1;

--test: cast dtltz column to bit/blob/clob types
select id, cast(dtltz as bit(20)) from tz_test order by 1;
select id, cast(dtltz as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(dtltz as blob)) from tz_test order by 1;
select id, clob_to_char(cast(dtltz as clob)) from tz_test order by 1;

--test: cast dttz column to bit/blob/clob types
select id, cast(dttz as bit(20)) from tz_test order by 1;
select id, cast(dttz as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(dttz as blob)) from tz_test order by 1;
select id, clob_to_char(cast(dttz as clob)) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
