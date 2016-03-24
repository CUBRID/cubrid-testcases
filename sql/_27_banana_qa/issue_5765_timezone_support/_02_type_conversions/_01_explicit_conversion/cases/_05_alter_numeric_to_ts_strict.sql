--cast numeric columns to TIMESTAMP(L)TZ types, in alter statement

autocommit off;

drop table if exists tz_test;

create table tz_test(a smallint, b integer, c bigint, d decimal(4, 2), e real, f double);
insert into tz_test values(1, 11, 111, 11.34, 99.999, 1234.5678);
commit;

set system parameters 'alter_table_change_type_strict=yes';
set timezone '-5:00';

--test: cast numeric columns to TIMESTAMP types
alter table tz_test change a a timestamp;
alter table tz_test change b b timestamp;
alter table tz_test change c c timestamp;
alter table tz_test change d d timestamp;
alter table tz_test change e e timestamp;
alter table tz_test change f f timestamp;
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast numeric columns to TIMESTAMPLTZ types
alter table tz_test change a a timestamp with local time zone;
alter table tz_test change a b timestamp with local time zone;
alter table tz_test change a c timestamp with local time zone;
alter table tz_test change a d timestamp with local time zone;
alter table tz_test change a e timestamp with local time zone;
alter table tz_test change a f timestamp with local time zone;
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast numeric columns to TIMESTAMPTZ types
alter table tz_test change a a timestamp with time zone;
alter table tz_test change a b timestamp with time zone;
alter table tz_test change a c timestamp with time zone;
alter table tz_test change a d timestamp with time zone;
alter table tz_test change a e timestamp with time zone;
alter table tz_test change a f timestamp with time zone;
desc tz_test;
select * from tz_test order by 1;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';
autocommit on;
