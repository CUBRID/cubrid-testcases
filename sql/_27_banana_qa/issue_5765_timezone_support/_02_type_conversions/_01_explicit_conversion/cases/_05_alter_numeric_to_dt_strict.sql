--cast numeric columns to DATETIME(L)TZ types, in alter statement

autocommit off;

drop table if exists tz_test;

create table tz_test(a smallint, b integer, c bigint, d decimal(4, 2), e real, f double);
insert into tz_test values(1, 11, 111, 11.34, 99.999, 1234.5678);
commit;

set system parameters 'alter_table_change_type_strict=yes';
set timezone '-5:00';

--test: cast numeric columns to DATETIME types
alter table tz_test change a a datetime;
alter table tz_test change b b datetime;
alter table tz_test change c c datetime;
alter table tz_test change d d datetime;
alter table tz_test change e e datetime;
alter table tz_test change f f datetime;
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast numeric columns to DATETIMELTZ types
alter table tz_test change a a datetime with local time zone;
alter table tz_test change a b datetime with local time zone;
alter table tz_test change a c datetime with local time zone;
alter table tz_test change a d datetime with local time zone;
alter table tz_test change a e datetime with local time zone;
alter table tz_test change a f datetime with local time zone;
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast numeric columns to DATETIMETZ types
alter table tz_test change a a datetime with time zone;
alter table tz_test change a b datetime with time zone;
alter table tz_test change a c datetime with time zone;
alter table tz_test change a d datetime with time zone;
alter table tz_test change a e datetime with time zone;
alter table tz_test change a f datetime with time zone;
desc tz_test;
select * from tz_test order by 1;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';
autocommit on;
