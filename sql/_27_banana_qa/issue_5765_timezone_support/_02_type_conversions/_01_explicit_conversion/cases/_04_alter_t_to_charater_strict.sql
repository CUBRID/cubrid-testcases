--cast TIME(L)TZ columns to character string data types, in alter statement, alter_table_change_type_strict=no

autocommit off;

drop table if exists tz_test;

create table tz_test(a int, t time, tltz datetime with local time zone, ttz datetime with time zone);

set timezone '+00:00';
insert into tz_test values(1, datetimeltz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01', datetimetz'2015-9-17 12:00:01');
insert into tz_test values(2, datetimeltz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00', datetimetz'2015-9-17 12:00:01 -10:00');
insert into tz_test values(3, datetimeltz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00', datetimetz'2015-9-17 12:00:01 +8:00');
insert into tz_test values(4, datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo', datetimetz'2015-9-17 12:00:01 Asia/Tokyo');

commit;

set system parameters 'alter_table_change_type_strict=yes';

--test: cast t column to character string types
alter table tz_test change t t char(10);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t varchar(10);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t varchar(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change t t string;
desc tz_test;
select * from tz_test order by 1;
rollback;
--test: [er]
alter table tz_test change t t enum('a', 'b', 'c');
alter table tz_test change t t enum('12:00:01 PM', '12:00:01 PM +08:00', '12:00:01 PM -10:00', '12:00:01 PM Asia/Tokyo', '12:00:01 PM UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tltz column to character string types
alter table tz_test change tltz tltz char(10);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz varchar(10);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz varchar(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tltz tltz string;
desc tz_test;
select * from tz_test order by 1;
rollback;
--test: [er]
alter table tz_test change tltz tltz enum('a', 'b', 'c');
alter table tz_test change tltz tltz enum('12:00:01 PM', '12:00:01 PM +08:00', '12:00:01 PM -10:00', '12:00:01 PM Asia/Tokyo', '12:00:01 PM +00:00');
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast ttz column to character string types
alter table tz_test change ttz ttz char(10);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz varchar(10);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz varchar(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ttz ttz string;
desc tz_test;
select * from tz_test order by 1;
rollback;
--test: [er]
alter table tz_test change ttz ttz enum('a', 'b', 'c');
alter table tz_test change ttz ttz enum('12:00:01 PM', '12:00:01 PM +08:00', '12:00:01 PM -10:00', '12:00:01 PM Asia/Tokyo', '12:00:01 PM +00:00');
desc tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';
autocommit on;
