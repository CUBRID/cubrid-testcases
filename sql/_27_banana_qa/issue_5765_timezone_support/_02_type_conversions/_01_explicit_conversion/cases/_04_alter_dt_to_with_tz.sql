--cast DATETIME(L)TZ columns to with time zone data types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(a int, dt datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimetz' 2019-01-02 12:00:01.999', datetimetz' 2019-01-02 12:00:01.999', datetimetz' 2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimetz' 2019-01-02 12:00:01.999 -10:00', datetimetz' 2019-01-02 12:00:01.999 -10:00', datetimetz' 2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimetz' 2019-01-02 12:00:01.999 +8:00', datetimetz' 2019-01-02 12:00:01.999 +8:00', datetimetz' 2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimetz' 2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz' 2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz' 2019-01-02 12:00:01.999 Asia/Tokyo');
commit;

set system parameters 'alter_table_change_type_strict=no';

--test: cast dt column to with time zone types
alter table tz_test change dt dt datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dt dt timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dt dt datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
--BUG: CUBRIDSUS-16974, resolved
alter table tz_test change dt dt datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dt dt timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dt dt datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast dtltz column to with time zone types
alter table tz_test change dtltz dtltz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
--BUG: CUBRIDSUS-16974, resolved
alter table tz_test change dtltz dtltz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast dttz column to with time zone types
alter table tz_test change dttz dttz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
