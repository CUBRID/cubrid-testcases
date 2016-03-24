--implicit conversion from DATETIME(L)TZ columns to numeric types, in update

autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'2020-12-1 20:00:00.999', datetimeltz'2020-12-1 20:00:00.999', datetimetz'2020-12-1 20:00:00.999 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(55), b varchar(200), c string, d enum('a', 'b', 'c'), e enum('08:00:00.999 PM 12/01/2020', '12:00:01.999 PM 01/02/2019 +08:00', '08:00:00.999 PM 12/01/2020 +09:00', '08:00:00.999 PM 12/01/2020 Asia/Seoul'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', 2, 1);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', 1, 3);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999 Asia/Seoul', '2020-12-1 20:00:00.999 Asia/Seoul', '2020-12-1 20:00:00.999 Asia/Seoul', 1, 4);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to numeric types
update character_types set a=datetime'1980-10-01 2:00:00.999';
update character_types set b=datetime'1980-10-01 2:00:00.999';
update character_types set c=datetime'1980-10-01 2:00:00.999';
update character_types set d=datetime'1980-10-01 2:00:00.999';
update character_types set e=datetime'2020-12-1 20:00:00.999';
select * from character_types order by id;
rollback;
--test: implicit conversion from ts column to numeric types
update character_types set a=(select ts from tz_test);
update character_types set b=(select ts from tz_test);
update character_types set c=(select ts from tz_test);
update character_types set d=(select ts from tz_test);
update character_types set e=(select ts from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from dtltz constant value to numeric types
update character_types set a=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update character_types set b=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update character_types set c=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update character_types set d=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update character_types set e=datetimeltz'2020-12-1 20:00:00.999 +9:00';
select * from character_types order by id;
rollback;
--test: implicit conversion from dtltz column to numeric types
update character_types set a=(select dtltz from tz_test);
update character_types set b=(select dtltz from tz_test);
update character_types set c=(select dtltz from tz_test);
update character_types set d=(select dtltz from tz_test);
update character_types set e=(select dtltz from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from dttz constant value to numeric types
update character_types set a=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update character_types set b=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update character_types set c=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update character_types set d=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update character_types set e=datetimetz'2020-12-1 20:00:00.999 America/Argentina/Jujuy';
select * from character_types order by id;
rollback;
--test: implicit conversion from dttz column to numeric types
update character_types set a=(select dttz from tz_test);
update character_types set b=(select dttz from tz_test);
update character_types set c=(select dttz from tz_test);
update character_types set d=(select dttz from tz_test);
update character_types set e=(select dttz from tz_test);
select * from character_types order by id;
rollback;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
