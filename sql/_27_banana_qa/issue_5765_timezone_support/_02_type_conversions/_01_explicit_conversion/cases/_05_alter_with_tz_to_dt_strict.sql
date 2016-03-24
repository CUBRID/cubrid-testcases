--cast date/time columns with timezone to DATETIME(L)TZ types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(
	c timestamp with local time zone, 
	d timestamp with time zone,
	e datetime with local time zone,
	f datetime with time zone
);
set timezone '+3:00';
insert into tz_test values(timestamptz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro', datetime'2019-12-10 3:40:56.999', datetimetz' 2019-12-10 3:40:56.999 Indian/Comoro');
commit;

set system parameters 'alter_table_change_type_strict=yes';

set timezone 'Pacific/Tarawa';
-- -6:00 DST
--test: cast date/time columns with timezone to DATETIME types
alter table tz_test modify c datetime;
alter table tz_test modify d datetime;
alter table tz_test modify e datetime;
alter table tz_test modify f datetime;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast date/time columns with timezone to DATETIMELTZ types
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;
alter table tz_test modify e datetime with local time zone;
alter table tz_test modify f datetime with local time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast date/time columns with timezone to DATETIMETZ types
alter table tz_test modify c datetime with time zone;
alter table tz_test modify d datetime with time zone;
alter table tz_test modify e datetime with time zone;
alter table tz_test modify f datetime with time zone;
show columns in tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';

autocommit on;
