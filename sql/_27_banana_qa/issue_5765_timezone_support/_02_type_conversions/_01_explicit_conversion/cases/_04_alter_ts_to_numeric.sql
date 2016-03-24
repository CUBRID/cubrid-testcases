--cast TIMESTAMP(L)TZ columns to numeric data types, in alter statement


drop table if exists tz_test;

create table tz_test(a int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestamptz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestamptz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestamptz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestamptz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

--test: [er] cast ts column to numeric types
alter table tz_test change ts ts short;
alter table tz_test change ts ts int;
alter table tz_test change ts ts bigint;
alter table tz_test change ts ts numeric(6, 2);
alter table tz_test change ts ts float;
alter table tz_test change ts ts double;
select * from tz_test order by 1;

--test: [er] cast tsltz column to numeric types
alter table tz_test change tsltz tsltz short;
alter table tz_test change tsltz tsltz int;
alter table tz_test change tsltz tsltz bigint;
alter table tz_test change tsltz tsltz numeric(6, 2);
alter table tz_test change tsltz tsltz float;
alter table tz_test change tsltz tsltz double;
select * from tz_test order by 1;

--test: [er] cast tstz column to numeric types
alter table tz_test change tstz tstz short;
alter table tz_test change tstz tstz int;
alter table tz_test change tstz tstz bigint;
alter table tz_test change tstz tstz numeric(6, 2);
alter table tz_test change tstz tstz float;
alter table tz_test change tstz tstz double;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
