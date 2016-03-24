--implicit conversion from TIME(L)TZ columns to numeric types, in update

autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (time'20:00:00', datetimeltz'2015-9-17 20:00:00', datetimetz'2015-9-17 20:00:00 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(55), b varchar(200), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM', '12:00:01 PM +08:00', '08:00:00 PM +09:00', '08:00:00 PM Asia/Seoul'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('20:00:00', '20:00:00', '20:00:00', 2, 1);
insert into character_types(a, b, c, d, e) values('20:00:00 +9:00', '20:00:00 +9:00', '20:00:00 +9:00', 1, 3);
insert into character_types(a, b, c, d, e) values('20:00:00 Asia/Seoul', '20:00:00 Asia/Seoul', '20:00:00 Asia/Seoul', 1, 4);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from t constant value to numeric types
update character_types set a=time'2:00:00';
update character_types set b=time'2:00:00';
update character_types set c=time'2:00:00';
update character_types set d=time'2:00:00';
update character_types set e=time'20:00:00';
select * from character_types order by id;
rollback;
--test: implicit conversion from t column to numeric types
update character_types set a=(select t from tz_test);
update character_types set b=(select t from tz_test);
update character_types set c=(select t from tz_test);
update character_types set d=(select t from tz_test);
update character_types set e=(select t from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from tltz constant value to numeric types
update character_types set a=datetimeltz'2015-9-17 2:00:00 -5:00';
update character_types set b=datetimeltz'2015-9-17 2:00:00 -5:00';
update character_types set c=datetimeltz'2015-9-17 2:00:00 -5:00';
update character_types set d=datetimeltz'2015-9-17 2:00:00 -5:00';
update character_types set e=datetimeltz'2015-9-17 20:00:00 +9:00';
select * from character_types order by id;
rollback;
--test: implicit conversion from tltz column to numeric types
update character_types set a=(select tltz from tz_test);
update character_types set b=(select tltz from tz_test);
update character_types set c=(select tltz from tz_test);
update character_types set d=(select tltz from tz_test);
update character_types set e=(select tltz from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from ttz constant value to numeric types
update character_types set a=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update character_types set b=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update character_types set c=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update character_types set d=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update character_types set e=datetimetz'2015-9-17 20:00:00 America/Argentina/Jujuy';
select * from character_types order by id;
rollback;
--test: implicit conversion from ttz column to numeric types
update character_types set a=(select ttz from tz_test);
update character_types set b=(select ttz from tz_test);
update character_types set c=(select ttz from tz_test);
update character_types set d=(select ttz from tz_test);
update character_types set e=(select ttz from tz_test);
select * from character_types order by id;
rollback;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
