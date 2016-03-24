--implicit conversion from TIME(L)TZ columns to date/time types, in update

autocommit off;

drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table date_time_types (id int auto_increment, a time, b date, c timestamp, d datetime);
insert into date_time_types(a, b, c, d) values(time'12:13:14', date'2000-10-10', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.299');
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time types
update date_time_types set a=time'2:00:00';
update date_time_types set b=time'2:00:00';
update date_time_types set c=time'2:00:00';
update date_time_types set d=time'2:00:00';
select * from date_time_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time types
update date_time_types set a=(select ts from tz_test);
update date_time_types set b=(select ts from tz_test);
update date_time_types set c=(select ts from tz_test);
update date_time_types set d=(select ts from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from tltz constant value to date/time types
update date_time_types set a=datetimeltz'2015-9-17 2:00:00 -5:00';
update date_time_types set b=datetimeltz'2015-9-17 2:00:00 -5:00';
update date_time_types set c=datetimeltz'2015-9-17 2:00:00 -5:00';
update date_time_types set d=datetimeltz'2015-9-17 2:00:00 -5:00';
select * from date_time_types order by id;
rollback;
--test: implicit conversion from tltz column to date/time types
update date_time_types set a=(select tltz from tz_test);
update date_time_types set b=(select tltz from tz_test);
update date_time_types set c=(select tltz from tz_test);
update date_time_types set d=(select tltz from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from ttz constant value to date/time types
update date_time_types set a=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update date_time_types set b=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update date_time_types set c=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update date_time_types set d=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
select * from date_time_types order by id;
rollback;
--test: implicit conversion from ttz column to date/time types
update date_time_types set a=(select ttz from tz_test);
update date_time_types set b=(select ttz from tz_test);
update date_time_types set c=(select ttz from tz_test);
update date_time_types set d=(select ttz from tz_test);
select * from date_time_types order by id;


drop table tz_test, date_time_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
