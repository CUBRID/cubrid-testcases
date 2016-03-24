--implicit conversion from TIMESTAMP(L)TZ columns to numeric types, in update

autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'2020-12-1 20:00:00', timestampltz'2020-12-1 20:00:00', timestamptz'2020-12-1 20:00:00 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(55), b varchar(200), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM 12/01/2020', '12:00:01 PM 01/02/2019 +08:00', '08:00:00 PM 12/01/2020 +09:00', '08:00:00 PM 12/01/2020 Asia/Seoul'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00', '2020-12-1 20:00:00', '2020-12-1 20:00:00', 2, 1);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', 1, 3);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00 Asia/Seoul', '2020-12-1 20:00:00 Asia/Seoul', '2020-12-1 20:00:00 Asia/Seoul', 1, 4);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to numeric types
update character_types set a=timestamp'1980-10-01 2:00:00';
update character_types set b=timestamp'1980-10-01 2:00:00';
update character_types set c=timestamp'1980-10-01 2:00:00';
update character_types set d=timestamp'1980-10-01 2:00:00';
update character_types set e=timestamp'2020-12-1 20:00:00';
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

--test: implicit conversion from tsltz constant value to numeric types
update character_types set a=timestampltz'1980-10-01 2:00:00 -5:00';
update character_types set b=timestampltz'1980-10-01 2:00:00 -5:00';
update character_types set c=timestampltz'1980-10-01 2:00:00 -5:00';
update character_types set d=timestampltz'1980-10-01 2:00:00 -5:00';
update character_types set e=timestampltz'2020-12-1 20:00:00 +9:00';
select * from character_types order by id;
rollback;
--test: implicit conversion from tsltz column to numeric types
update character_types set a=(select tsltz from tz_test);
update character_types set b=(select tsltz from tz_test);
update character_types set c=(select tsltz from tz_test);
update character_types set d=(select tsltz from tz_test);
update character_types set e=(select tsltz from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from tstz constant value to numeric types
update character_types set a=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update character_types set b=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update character_types set c=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update character_types set d=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update character_types set e=timestamptz'2020-12-1 20:00:00 America/Argentina/Jujuy';
select * from character_types order by id;
rollback;
--test: implicit conversion from tstz column to numeric types
update character_types set a=(select tstz from tz_test);
update character_types set b=(select tstz from tz_test);
update character_types set c=(select tstz from tz_test);
update character_types set d=(select tstz from tz_test);
update character_types set e=(select tstz from tz_test);
select * from character_types order by id;
rollback;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
