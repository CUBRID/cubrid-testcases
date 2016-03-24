--implicit conversion from TIMESTAMP(L)TZ columns to character string types, in insert 

autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone 'Asia/Seoul';
insert into tz_test(ts, tsltz, tstz) values (timestamptz'2020-12-1 20:00:00', timestamptz'2020-12-1 20:00:00', timestamptz'2020-12-1 20:00:00 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(100), b varchar(100), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM 12/01/2020', '12:00:01 PM 01/02/2019 +08:00', '08:00:00 PM 12/01/2020 +09:00', '08:00:00 PM 12/01/2020 Asia/Seoul'));
commit;

--test: implicit conversion from ts constant value to character string types
insert into character_types(a) values (timestamp'1980-10-01 2:00:00');
insert into character_types(b) values (timestamp'1980-10-01 2:00:00');
insert into character_types(c) values (timestamp'1980-10-01 2:00:00');
insert into character_types(d) values (timestamp'1980-10-01 2:00:00');
insert into character_types(e) values (timestamp'2020-12-1 20:00:00');
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

--test: implicit conversion from tsltz constant value to character string types
insert into character_types(a) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into character_types(b) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into character_types(c) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into character_types(d) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into character_types(e) values (timestampltz'2020-12-1 20:00:00 +9:00');
select * from character_types order by id;
rollback;
--test: implicit conversion from tsltz column to character string types
insert into character_types(a) values (select tsltz from tz_test);
insert into character_types(b) values (select tsltz from tz_test);
insert into character_types(c) values (select tsltz from tz_test);
insert into character_types(d) values (select tsltz from tz_test);
insert into character_types(e) values (select tsltz from tz_test);
select * from character_types order by id;
rollback;

--test: implicit conversion from tstz constant value to character string types
insert into character_types(a) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into character_types(b) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into character_types(c) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into character_types(d) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into character_types(e) values (timestamptz'2020-12-1 20:00:00 America/Argentina/Jujuy');
select * from character_types order by id;
rollback;
--test: implicit conversion from tstz column to character string types
insert into character_types(a) values (select tstz from tz_test);
insert into character_types(b) values (select tstz from tz_test);
insert into character_types(c) values (select tstz from tz_test);
insert into character_types(d) values (select tstz from tz_test);
insert into character_types(e) values (select tstz from tz_test);
select * from character_types order by id;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
