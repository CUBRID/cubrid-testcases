--cast TIMESTAMP(L)TZ columns to bit/blob/clob data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

--test: [er] cast ts column to bit/blob/clob types
alter table tz_test modify ts bit(20);
alter table tz_test modify ts bit varying(10);
alter table tz_test modify ts blob;
alter table tz_test modify ts clob;
select * from tz_test order by 1;

--test: [er] cast tsltz column to bit/blob/clob types
alter table tz_test modify tsltz bit(20);
alter table tz_test modify tsltz bit varying(10);
alter table tz_test modify tsltz blob;
alter table tz_test modify tsltz clob;
select * from tz_test order by 1;

--test: [er] cast tstz column to bit/blob/clob types
alter table tz_test modify tstz bit(20);
alter table tz_test modify tstz bit varying(10);
alter table tz_test modify tstz blob;
alter table tz_test modify tstz clob;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
