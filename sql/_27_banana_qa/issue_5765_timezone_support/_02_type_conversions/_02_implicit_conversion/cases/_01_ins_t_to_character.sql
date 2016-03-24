--implicit conversion from TIME(L)TZ columns to character string types, in insert 

autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone 'Asia/Seoul';
insert into tz_test(t, tltz, ttz) values (datetimetz'2015-9-17 20:00:00', datetimetz'2015-9-17 20:00:00', datetimetz'2015-9-17 20:00:00 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(100), b varchar(100), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM', '12:00:01 PM +08:00', '08:00:00 PM +09:00', '08:00:00 PM Asia/Seoul'));
commit;

--test: implicit conversion from t constant value to character string types
insert into character_types(a) values (time'2:00:00');
insert into character_types(b) values (time'2:00:00');
insert into character_types(c) values (time'2:00:00');
insert into character_types(d) values (time'2:00:00');
insert into character_types(e) values (time'20:00:00');
select * from character_types order by id;
rollback;
--test: implicit conversion from t column to character string types
insert into character_types(a) values (select t from tz_test);
insert into character_types(b) values (select t from tz_test);
insert into character_types(c) values (select t from tz_test);
insert into character_types(d) values (select t from tz_test);
insert into character_types(e) values (select t from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from tltz constant value to character string types
insert into character_types(a) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into character_types(b) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into character_types(c) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into character_types(d) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into character_types(e) values (datetimeltz'2015-9-17 20:00:00 +9:00');
select * from character_types order by id;
rollback;
--test: implicit conversion from tltz column to character string types
insert into character_types(a) values (select tltz from tz_test);
insert into character_types(b) values (select tltz from tz_test);
insert into character_types(c) values (select tltz from tz_test);
insert into character_types(d) values (select tltz from tz_test);
insert into character_types(e) values (select tltz from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from ttz constant value to character string types
insert into character_types(a) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into character_types(b) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into character_types(c) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into character_types(d) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into character_types(e) values (datetimetz'2015-9-17 20:00:00 America/Argentina/Jujuy');
select * from character_types order by id;
rollback;
--test: implicit conversion from ttz column to character string types
insert into character_types(a) values (select ttz from tz_test);
insert into character_types(b) values (select ttz from tz_test);
insert into character_types(c) values (select ttz from tz_test);
insert into character_types(d) values (select ttz from tz_test);
insert into character_types(e) values (select ttz from tz_test);
select * from character_types order by id;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
