--cast DATETIME(L)TZ columns to date/time data types, in alter statement, alter_table_change_type_strict=yes

autocommit off;
drop table if exists tz_test;

create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');
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
alter table tz_test change ts ts datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast dtltz column to date/time types
alter table tz_test change dtltz dtltz date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast dttz column to date/time types
alter table tz_test change dttz dttz date;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz time;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';

autocommit on;
