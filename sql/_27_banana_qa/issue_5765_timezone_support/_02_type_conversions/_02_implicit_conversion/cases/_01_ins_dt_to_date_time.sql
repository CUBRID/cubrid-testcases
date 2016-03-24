--implicit conversion from DATETIME(L)TZ columns to date/time types, in insert 

autocommit off;
drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk'); 
-- 'Asia/Yakutsk' Russia 9:00

create table date_time_types (id int auto_increment, a time, b date, c timestamp, d datetime);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time types
insert into date_time_types(a) values (datetime'1980-10-01 2:00:00.999');
insert into date_time_types(b) values (datetime'1980-10-01 2:00:00.999');
insert into date_time_types(c) values (datetime'1980-10-01 2:00:00.999');
insert into date_time_types(d) values (datetime'1980-10-01 2:00:00.999');
select * from date_time_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time types
insert into date_time_types(a) values (select ts from tz_test);
insert into date_time_types(b) values (select ts from tz_test);
insert into date_time_types(c) values (select ts from tz_test);
insert into date_time_types(d) values (select ts from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from dtltz constant value to date/time types
insert into date_time_types(a) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into date_time_types(b) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into date_time_types(c) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into date_time_types(d) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
select * from date_time_types order by id;
rollback;
--test: implicit conversion from dtltz column to date/time types
insert into date_time_types(a) values (select dtltz from tz_test);
insert into date_time_types(b) values (select dtltz from tz_test);
insert into date_time_types(c) values (select dtltz from tz_test);
insert into date_time_types(d) values (select dtltz from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from dttz constant value to date/time types
select datetimetz '1980-10-01 2:00:00.999 America/Argentina/Jujuy';
insert into date_time_types(a) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
-- -3:00
insert into date_time_types(b) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into date_time_types(c) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into date_time_types(d) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
select * from date_time_types order by id;
rollback;
--test: implicit conversion from dttz column to date/time types
insert into date_time_types(a) values (select dttz from tz_test);
insert into date_time_types(b) values (select dttz from tz_test);
insert into date_time_types(c) values (select dttz from tz_test);
insert into date_time_types(d) values (select dttz from tz_test);
select * from date_time_types order by id;


drop table tz_test, date_time_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
