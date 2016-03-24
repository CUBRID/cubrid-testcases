--implicit conversion from DATETIME(L)TZ columns to character string types, in insert 

autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone 'Asia/Seoul';
insert into tz_test(ts, dtltz, dttz) values (datetimetz'2020-12-1 20:00:00.999', datetimetz'2020-12-1 20:00:00.999', datetimetz'2020-12-1 20:00:00.999 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(100), b varchar(100), c string, d enum('a', 'b', 'c'), e enum('08:00:00.999 PM 12/01/2020', '12:00:01.999 PM 01/02/2019 +08:00', '08:00:00.999 PM 12/01/2020 +09:00', '08:00:00.999 PM 12/01/2020 Asia/Seoul'));
commit;

--test: implicit conversion from ts constant value to character string types
insert into character_types(a) values (datetime'1980-10-01 2:00:00.999');
insert into character_types(b) values (datetime'1980-10-01 2:00:00.999');
insert into character_types(c) values (datetime'1980-10-01 2:00:00.999');
insert into character_types(d) values (datetime'1980-10-01 2:00:00.999');
insert into character_types(e) values (datetime'2020-12-1 20:00:00.999');
select * from character_types order by id;
rollback;
--test: implicit conversion from ts column to character string types
insert into character_types(a) values (select ts from tz_test);
insert into character_types(b) values (select ts from tz_test);
insert into character_types(c) values (select ts from tz_test);
insert into character_types(d) values (select ts from tz_test);
insert into character_types(e) values (select ts from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from dtltz constant value to character string types
insert into character_types(a) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into character_types(b) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into character_types(c) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into character_types(d) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into character_types(e) values (datetimeltz'2020-12-1 20:00:00.999 +9:00');
select * from character_types order by id;
rollback;
--test: implicit conversion from dtltz column to character string types
insert into character_types(a) values (select dtltz from tz_test);
insert into character_types(b) values (select dtltz from tz_test);
insert into character_types(c) values (select dtltz from tz_test);
insert into character_types(d) values (select dtltz from tz_test);
insert into character_types(e) values (select dtltz from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from dttz constant value to character string types
insert into character_types(a) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into character_types(b) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into character_types(c) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into character_types(d) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into character_types(e) values (datetimetz'2020-12-1 20:00:00.999 America/Argentina/Jujuy');
select * from character_types order by id;
rollback;
--test: implicit conversion from dttz column to character string types
insert into character_types(a) values (select dttz from tz_test);
insert into character_types(b) values (select dttz from tz_test);
insert into character_types(c) values (select dttz from tz_test);
insert into character_types(d) values (select dttz from tz_test);
insert into character_types(e) values (select dttz from tz_test);
select * from character_types order by id;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
