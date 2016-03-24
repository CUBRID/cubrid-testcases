--cast TIME(L)TZ columns to bit/lob data types


drop table if exists tz_test;

create table tz_test(id int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '-10:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

--test: cast ts column to bit/blob/clob types
select id, cast(ts as bit(20)) from tz_test order by 1;
select id, cast(ts as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(ts as blob)) from tz_test order by 1;
select id, clob_to_char(cast(ts as clob)) from tz_test order by 1;

--test: cast tltz column to bit/blob/clob types
select id, cast(tltz as bit(20)) from tz_test order by 1;
select id, cast(tltz as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(tltz as blob)) from tz_test order by 1;
select id, clob_to_char(cast(tltz as clob)) from tz_test order by 1;

--test: cast ttz column to bit/blob/clob types
select id, cast(ttz as bit(20)) from tz_test order by 1;
select id, cast(ttz as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(ttz as blob)) from tz_test order by 1;
select id, clob_to_char(cast(ttz as clob)) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
