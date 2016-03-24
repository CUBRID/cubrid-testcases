--implicit conversion from TIMESTAMP(L)TZ columns to date/time types, in insert 

autocommit off;
drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk'); 
-- 'Asia/Yakutsk' Russia 9:00

create table date_time_types (id int auto_increment, a time, b date, c timestamp, d datetime);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time types
insert into date_time_types(a) values (timestamp'1980-10-01 2:00:00');
insert into date_time_types(b) values (timestamp'1980-10-01 2:00:00');
insert into date_time_types(c) values (timestamp'1980-10-01 2:00:00');
insert into date_time_types(d) values (timestamp'1980-10-01 2:00:00');
select * from date_time_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time types
insert into date_time_types(a) values (select ts from tz_test);
insert into date_time_types(b) values (select ts from tz_test);
insert into date_time_types(c) values (select ts from tz_test);
insert into date_time_types(d) values (select ts from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from tsltz constant value to date/time types
insert into date_time_types(a) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into date_time_types(b) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into date_time_types(c) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into date_time_types(d) values (timestampltz'1980-10-01 2:00:00 -5:00');
select * from date_time_types order by id;
rollback;
--test: implicit conversion from tsltz column to date/time types
insert into date_time_types(a) values (select tsltz from tz_test);
insert into date_time_types(b) values (select tsltz from tz_test);
insert into date_time_types(c) values (select tsltz from tz_test);
insert into date_time_types(d) values (select tsltz from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from tstz constant value to date/time types
--BUG: CUBRIDSUS-15041, resolved
select timestamptz '1980-10-01 2:00:00 America/Argentina/Jujuy';
insert into date_time_types(a) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
-- -3:00
insert into date_time_types(b) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into date_time_types(c) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into date_time_types(d) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
--BUG: CUBRIDSUS-15152, resolved
select * from date_time_types order by id;
rollback;
--test: implicit conversion from tstz column to date/time types
insert into date_time_types(a) values (select tstz from tz_test);
insert into date_time_types(b) values (select tstz from tz_test);
insert into date_time_types(c) values (select tstz from tz_test);
insert into date_time_types(d) values (select tstz from tz_test);
select * from date_time_types order by id;


drop table tz_test, date_time_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
