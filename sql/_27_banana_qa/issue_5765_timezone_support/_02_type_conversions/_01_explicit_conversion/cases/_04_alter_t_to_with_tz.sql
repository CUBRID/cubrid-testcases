--cast TIME(L)TZ columns to with time zone data types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(a int, ts time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');
commit;

set system parameters 'alter_table_change_type_strict=no';

--test: cast ts column to with time zone types
alter table tz_test change ts ts datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tltz column to with time zone types
alter table tz_test change tltz tltz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast ttz column to with time zone types
alter table tz_test change ttz ttz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
