--cast character string columns to DATETIME(L)TZ types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(id int, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 +09:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo'));
insert into tz_test values(1, 'aaa', 'bbb', 'ccc', 3, 2);
insert into tz_test values(2, '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', 3, 1);
insert into tz_test values(3, '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', 2, 3);
insert into tz_test values(4, '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', 1, 4);
insert into tz_test values(5, '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', 1, 4);
commit;

set system parameters 'alter_table_change_type_strict=no';
set timezone 'Europe/Malta';
-- 1:00 EU


--test: cast character string columns to DATETIME types
alter table tz_test modify a datetime;
alter table tz_test modify b datetime;
alter table tz_test modify c datetime;
alter table tz_test modify d datetime;
alter table tz_test modify e datetime;
show full columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast character string columns to DATETIMELTZ types
alter table tz_test modify a datetime with local time zone;
alter table tz_test modify b datetime with local time zone;
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;
alter table tz_test modify e datetime with local time zone;
show full columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast character string columns to DATETIMETZ types
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
