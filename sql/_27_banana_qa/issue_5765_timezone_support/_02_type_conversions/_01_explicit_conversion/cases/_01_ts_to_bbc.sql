--cast TIMESTAMP(L)TZ columns to bit/lob data types


drop table if exists tz_test;

create table tz_test(id int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

--test: cast ts column to bit/blob/clob types
select id, cast(ts as bit(20)) from tz_test order by 1;
select id, cast(ts as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(ts as blob)) from tz_test order by 1;
select id, clob_to_char(cast(ts as clob)) from tz_test order by 1;

--test: cast tsltz column to bit/blob/clob types
select id, cast(tsltz as bit(20)) from tz_test order by 1;
select id, cast(tsltz as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(tsltz as blob)) from tz_test order by 1;
select id, clob_to_char(cast(tsltz as clob)) from tz_test order by 1;

--test: cast tstz column to bit/blob/clob types
select id, cast(tstz as bit(20)) from tz_test order by 1;
select id, cast(tstz as bit varying) from tz_test order by 1;
select id, blob_to_bit(cast(tstz as blob)) from tz_test order by 1;
select id, clob_to_char(cast(tstz as clob)) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
