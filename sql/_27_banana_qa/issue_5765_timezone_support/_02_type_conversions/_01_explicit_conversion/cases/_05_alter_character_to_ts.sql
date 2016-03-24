--cast character string columns to TIMESTAMP(L)TZ types, in alter statement

autocommit off;
drop table if exists tz_test;

create table tz_test(id int, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 +09:00', '12:00:01 PM 01/02/2019 Asia/Tokyo'));
insert into tz_test values(1, 'aaa', 'bbb', 'ccc', 3, 2);
insert into tz_test values(2, '2020-12-1 20:00:00', '2020-12-1 20:00:00', '2020-12-1 20:00:00', 3, 1);
insert into tz_test values(3, '2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', 2, 3);
insert into tz_test values(4, '2020-12-1 20:00:00 Asia/Tokyo', '2020-12-1 20:00:00 Asia/Tokyo', '2020-12-1 20:00:00 Asia/Tokyo', 1, 4);
insert into tz_test values(5, '2020-12-1 20:00:00.789 Asia/Tokyo', '2020-12-1 20:00:00.789 Asia/Tokyo', '2020-12-1 20:00:00.789 Asia/Tokyo', 1, 4);
commit;

set system parameters 'alter_table_change_type_strict=no';
set timezone 'Europe/Malta';
-- 1:00 EU


--test: cast character string columns to TIMESTAMP types
alter table tz_test modify a timestamp;
alter table tz_test modify b timestamp;
alter table tz_test modify c timestamp;
alter table tz_test modify d timestamp;
alter table tz_test modify e timestamp;
show full columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast character string columns to TIMESTAMPLTZ types
alter table tz_test modify a timestamp with local time zone;
alter table tz_test modify b timestamp with local time zone;
alter table tz_test modify c timestamp with local time zone;
alter table tz_test modify d timestamp with local time zone;
alter table tz_test modify e timestamp with local time zone;
show full columns in tz_test;
select * from tz_test order by 1;
rollback;

--test: cast character string columns to TIMESTAMPTZ types
alter table tz_test modify a timestamp with time zone;
alter table tz_test modify b timestamp with time zone;
alter table tz_test modify c timestamp with time zone;
alter table tz_test modify d timestamp with time zone;
alter table tz_test modify e timestamp with time zone;
show full columns in tz_test;
select * from tz_test order by 1;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';

autocommit on;
