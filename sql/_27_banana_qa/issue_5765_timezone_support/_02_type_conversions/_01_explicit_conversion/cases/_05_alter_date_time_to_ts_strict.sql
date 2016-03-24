--cast date/time columns to TIMESTAMP(L)TZ types, in alter statement, alter_table_change_type_strict=yes

autocommit off;

drop table if exists tz_test;

create table tz_test(a date, b time, c timestamp, d datetime);
insert into tz_test values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.299');
commit;

set system parameters 'alter_table_change_type_strict=yes';

set timezone '+3:00';
--test: cast date/time columns to TIMESTAMP types
alter table tz_test modify a timestamp;
alter table tz_test modify b timestamp;
alter table tz_test modify c timestamp;
alter table tz_test modify d timestamp;
desc tz_test;
select * from tz_test order by 1;
rollback;

set timezone '-3:00';
--test: cast date/time columns to TIMESTAMPLTZ types
alter table tz_test modify a timestamp with local time zone;
alter table tz_test modify b timestamp with local time zone;
alter table tz_test modify c timestamp with local time zone;
alter table tz_test modify d timestamp with local time zone;
desc tz_test;
select * from tz_test order by 1;
rollback;

set timezone 'America/Argentina/San_Juan';
--test: cast date/time columns to TIMESTAMPTZ types
alter table tz_test modify a timestamp with time zone;
alter table tz_test modify b timestamp with time zone;
alter table tz_test modify c timestamp with time zone;
alter table tz_test modify d timestamp with time zone;
desc tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
