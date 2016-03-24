--cast date/time columns with timezone to TIMESTAMP(L)TZ types, in alter statement, alter_table_change_type_strict=yes

autocommit off;
drop table if exists tz_test;

create table tz_test(
	c timestamp with local time zone, 
	d timestamp with time zone,
	e datetime with local time zone,
	f datetime with time zone
);
set timezone '+3:00';
insert into tz_test values(timestamptz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro', datetimeltz'2019-12-10 3:40:56.299',datetimetz' 2019-12-10 3:40:56.299 Indian/Comoro');
commit;

set system parameters 'alter_table_change_type_strict=yes';

set timezone 'Pacific/Saipan';
--test: cast date/time columns with timezone to TIMESTAMP types
alter table tz_test modify c timestamp;
alter table tz_test modify d timestamp;
alter table tz_test modify e timestamp;
alter table tz_test modify f timestamp;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast date/time columns with timezone to TIMESTAMPLTZ types
alter table tz_test modify c timestamp with local time zone;
alter table tz_test modify d timestamp with local time zone;
alter table tz_test modify e timestamp with local time zone;
alter table tz_test modify f timestamp with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast date/time columns with timezone to TIMESTAMPTZ types
alter table tz_test modify c timestamp with time zone;
alter table tz_test modify d timestamp with time zone;
alter table tz_test modify e timestamp with time zone;
alter table tz_test modify f timestamp with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';

autocommit on;
