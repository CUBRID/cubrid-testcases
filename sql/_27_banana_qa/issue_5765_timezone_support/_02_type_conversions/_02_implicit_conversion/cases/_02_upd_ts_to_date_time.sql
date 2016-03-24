--implicit conversion from TIMESTAMP(L)TZ columns to date/time types, in update

autocommit off;

drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table date_time_types (id int auto_increment, a time, b date, c timestamp, d datetime);
insert into date_time_types(a, b, c, d) values(time'12:13:14', date'2000-10-10', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.299');
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time types
update date_time_types set a=timestamp'1980-10-01 2:00:00';
update date_time_types set b=timestamp'1980-10-01 2:00:00';
update date_time_types set c=timestamp'1980-10-01 2:00:00';
update date_time_types set d=timestamp'1980-10-01 2:00:00';
select * from date_time_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time types
update date_time_types set a=(select ts from tz_test);
update date_time_types set b=(select ts from tz_test);
update date_time_types set c=(select ts from tz_test);
update date_time_types set d=(select ts from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from tsltz constant value to date/time types
update date_time_types set a=timestampltz'1980-10-01 2:00:00 -5:00';
update date_time_types set b=timestampltz'1980-10-01 2:00:00 -5:00';
update date_time_types set c=timestampltz'1980-10-01 2:00:00 -5:00';
update date_time_types set d=timestampltz'1980-10-01 2:00:00 -5:00';
select * from date_time_types order by id;
rollback;
--test: implicit conversion from tsltz column to date/time types
update date_time_types set a=(select tsltz from tz_test);
update date_time_types set b=(select tsltz from tz_test);
update date_time_types set c=(select tsltz from tz_test);
update date_time_types set d=(select tsltz from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from tstz constant value to date/time types
update date_time_types set a=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update date_time_types set b=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update date_time_types set c=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update date_time_types set d=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
select * from date_time_types order by id;
rollback;
--test: implicit conversion from tstz column to date/time types
update date_time_types set a=(select tstz from tz_test);
update date_time_types set b=(select tstz from tz_test);
update date_time_types set c=(select tstz from tz_test);
update date_time_types set d=(select tstz from tz_test);
select * from date_time_types order by id;


drop table tz_test, date_time_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
