--implicit conversion from TIME(L)TZ columns to date/time types, in insert 

autocommit off;
drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (datetimetz'2015-9-17 2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk'); 

create table date_time_types (id int auto_increment, a time, b date, c timestamp, d datetime);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from t constant value to date/time types
insert into date_time_types(a) values (time'2:00:00');
insert into date_time_types(b) values (time'2:00:00');
insert into date_time_types(c) values (time'2:00:00');
insert into date_time_types(d) values (time'2:00:00');
select * from date_time_types order by id; 
rollback;
--test: implicit conversion from t column to date/time types
insert into date_time_types(a) values (select t from tz_test);
insert into date_time_types(b) values (select t from tz_test);
insert into date_time_types(c) values (select t from tz_test);
insert into date_time_types(d) values (select t from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from tltz constant value to date/time types
insert into date_time_types(a) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into date_time_types(b) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into date_time_types(c) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into date_time_types(d) values (datetimeltz'2015-9-17 2:00:00 -5:00');
select * from date_time_types order by id;
rollback;
--test: implicit conversion from tltz column to date/time types
insert into date_time_types(a) values (select tltz from tz_test);
insert into date_time_types(b) values (select tltz from tz_test);
insert into date_time_types(c) values (select tltz from tz_test);
insert into date_time_types(d) values (select tltz from tz_test);
select * from date_time_types order by id;
rollback;

--test: implicit conversion from ttz constant value to date/time types
insert into date_time_types(a) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy'); 
insert into date_time_types(b) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into date_time_types(c) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into date_time_types(d) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
select * from date_time_types order by id;
rollback;
--test: implicit conversion from ttz column to date/time types
insert into date_time_types(a) values (select ttz from tz_test);
insert into date_time_types(b) values (select ttz from tz_test);
insert into date_time_types(c) values (select ttz from tz_test);
insert into date_time_types(d) values (select ttz from tz_test);
select * from date_time_types order by id;


drop table tz_test, date_time_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
