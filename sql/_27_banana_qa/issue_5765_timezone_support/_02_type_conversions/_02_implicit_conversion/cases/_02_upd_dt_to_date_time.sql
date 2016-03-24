--implicit conversion from DATETIME(L)TZ columns to date/time types, in update

autocommit off;

drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table date_time_types (id int auto_increment, a time, b date, c timestamp, d timestamp);
insert into date_time_types(a, b, c, d) values(time'12:13:14', date'2000-10-10', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.999');
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time types
update date_time_types set a=datetime'1980-10-01 2:00:00.999';
update date_time_types set b=datetime'1980-10-01 2:00:00.999';
update date_time_types set c=datetime'1980-10-01 2:00:00.999';
update date_time_types set d=datetime'1980-10-01 2:00:00.999';
select * from date_time_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time types
update date_time_types set a=(select ts from tz_test);
update date_time_types set b=(select ts from tz_test);
update date_time_types set c=(select ts from tz_test);
update date_time_types set d=(select ts from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from dtltz constant value to date/time types
update date_time_types set a=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update date_time_types set b=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update date_time_types set c=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update date_time_types set d=datetimeltz'1980-10-01 2:00:00.999 -5:00';
select * from date_time_types order by id;
rollback;
--test: implicit conversion from dtltz column to date/time types
update date_time_types set a=(select dtltz from tz_test);
update date_time_types set b=(select dtltz from tz_test);
update date_time_types set c=(select dtltz from tz_test);
update date_time_types set d=(select dtltz from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from dttz constant value to date/time types
update date_time_types set a=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update date_time_types set b=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update date_time_types set c=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update date_time_types set d=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
select * from date_time_types order by id;
rollback;
--test: implicit conversion from dttz column to date/time types
update date_time_types set a=(select dttz from tz_test);
update date_time_types set b=(select dttz from tz_test);
update date_time_types set c=(select dttz from tz_test);
update date_time_types set d=(select dttz from tz_test);
select * from date_time_types order by id;


drop table tz_test, date_time_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
