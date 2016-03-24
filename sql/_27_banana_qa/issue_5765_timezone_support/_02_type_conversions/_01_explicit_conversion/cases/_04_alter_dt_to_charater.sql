--cast DATETIME(L)TZ columns to character string data types, in alter statement, alter_table_change_type_strict=no

autocommit off;

drop table if exists tz_test;

create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -10:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

commit;

set system parameters 'alter_table_change_type_strict=no';

--test: cast ts column to character string types
--BUG:
alter table tz_test change ts ts char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts char(64);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts varchar(15);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts varchar(64);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts string;
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts enum('a', 'b', 'c');
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast dtltz column to character string types
alter table tz_test change dtltz dtltz char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz char(64);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz varchar(15);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz varchar(64);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz string;
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz enum('a', 'b', 'c');
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dtltz dtltz enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 Etc/UTC UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast dttz column to character string types
alter table tz_test change dttz dttz char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz char(64);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz varchar(15);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz varchar(64);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz string;
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz enum('a', 'b', 'c');
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change dttz dttz enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 Etc/UTC UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
