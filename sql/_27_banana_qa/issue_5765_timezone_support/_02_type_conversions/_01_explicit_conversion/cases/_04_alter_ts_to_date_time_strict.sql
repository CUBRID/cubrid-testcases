--cast TIMESTAMP(L)TZ columns to date/time data types, in alter statement, alter_table_change_type_strict=yes

autocommit off;
drop table if exists tz_test;

create table tz_test(a int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestamptz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestamptz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestamptz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestamptz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');
commit;

set system parameters 'alter_table_change_type_strict=yes';

--test: cast ts column to date/time types
alter table tz_test change ts ts date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tsltz column to date/time types
alter table tz_test change tsltz tsltz date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tstz column to date/time types
alter table tz_test change tstz tstz date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';

autocommit on;
