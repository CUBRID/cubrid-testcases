--cast date/time columns to DATETIME(L)TZ types, in alter statement

autocommit off;

drop table if exists tz_test;

create table tz_test(a date, b time, c timestamp, d datetime);
insert into tz_test values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.999');
commit;

set system parameters 'alter_table_change_type_strict=no';

set timezone '+3:00';
--test: cast date/time columns to DATETIME types
alter table tz_test modify a datetime;
alter table tz_test modify b datetime;
alter table tz_test modify c datetime;
alter table tz_test modify d datetime;
desc tz_test;
select * from tz_test order by 1;
rollback;

set timezone '-3:00';
--test: cast date/time columns to DATETIMELTZ types
alter table tz_test modify a datetime with local time zone;
alter table tz_test modify b datetime with local time zone;
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;
desc tz_test;
select * from tz_test order by 1;
rollback;

set timezone 'America/Argentina/San_Juan';
--test: cast date/time columns to DATETIMETZ types
alter table tz_test modify a datetime with time zone;
alter table tz_test modify b datetime with time zone;
alter table tz_test modify c datetime with time zone;
alter table tz_test modify d datetime with time zone;
desc tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
