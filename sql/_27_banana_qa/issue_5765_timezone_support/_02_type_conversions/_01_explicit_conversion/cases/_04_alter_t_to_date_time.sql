--cast TIME(L)TZ columns to date/time data types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(a int, t time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimeltz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');
commit;

set system parameters 'alter_table_change_type_strict=no';

--test: cast t column to date/time types
alter table tz_test change t t date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tltz column to date/time types
alter table tz_test change tltz tltz date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
--BUG: CUBRIDSUS-16998, resolved
alter table tz_test change tltz tltz time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast ttz column to date/time types
alter table tz_test change ttz ttz date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
