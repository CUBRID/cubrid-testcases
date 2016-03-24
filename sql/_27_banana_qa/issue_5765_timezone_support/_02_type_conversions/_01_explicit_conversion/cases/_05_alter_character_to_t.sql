--cast character string columns to TIME(L)TZ types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(id int, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('12:00:01 PM', '12:00:01 PM +08:00', '12:00:01 PM +09:00', '12:00:01 PM Asia/Tokyo'));
insert into tz_test values(1, 'aaa', 'bbb', 'ccc', 3, 2);
insert into tz_test values(2, '20:00:00', '20:00:00', '20:00:00', 3, 1);
insert into tz_test values(3, '20:00:00 +9:00', '20:00:00 +9:00', '20:00:00 +9:00', 2, 3);
insert into tz_test values(4, '20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', 1, 4);
insert into tz_test values(5, '20:00:00.789 Asia/Tokyo', '20:00:00.789 Asia/Tokyo', '20:00:00.789 Asia/Tokyo', 1, 4);
commit;

set system parameters 'alter_table_change_type_strict=no';
set timezone '+2:00';


--test: cast character string columns to TIME types
alter table tz_test modify a time;
alter table tz_test modify b time;
alter table tz_test modify c time;
alter table tz_test modify d time;
alter table tz_test modify e time;
show full columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast character string columns to TIMELTZ types
alter table tz_test modify a datetime with local time zone;
alter table tz_test modify b datetime with local time zone;
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;
alter table tz_test modify e datetime with local time zone;
show full columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast character string columns to TIMETZ types
alter table tz_test modify a datetime with time zone;
alter table tz_test modify b datetime with time zone;
alter table tz_test modify c datetime with time zone;
alter table tz_test modify d datetime with time zone;
alter table tz_test modify e datetime with time zone;
show full columns in tz_test;
select * from tz_test order by 1;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';

autocommit on;
