--implicit conversion from TIME(L)TZ columns to date/time with time zone types, in insert 

autocommit off;
drop table if exists tz_test;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table with_tz_types (
	id int auto_increment,
        c timestamp with local time zone,
        d timestamp with time zone,
        e datetime with local time zone,
        f datetime with time zone
);
commit;

set timezone '+9:00';
--test: implicit conversion from t constant value to date/time with time zone types
insert into with_tz_types(c) values (time'2:00:00');
insert into with_tz_types(d) values (time'2:00:00');
insert into with_tz_types(e) values (time'2:00:00');
insert into with_tz_types(f) values (time'2:00:00');
select * from with_tz_types order by id; 
rollback;
--test: implicit conversion from t column to date/time with time zone types
insert into with_tz_types(c) values (select t from tz_test);
insert into with_tz_types(d) values (select t from tz_test);
insert into with_tz_types(e) values (select t from tz_test);
insert into with_tz_types(f) values (select t from tz_test);
select * from with_tz_types order by id;
rollback;

set timezone 'Asia/Seoul';
--test: implicit conversion from tltz constant value to date/time with time zone types
insert into with_tz_types(c) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into with_tz_types(d) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into with_tz_types(e) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into with_tz_types(f) values (datetimeltz'2015-9-17 2:00:00 -5:00');
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from tltz column to date/time with time zone types
insert into with_tz_types(c) values (select tltz from tz_test);
insert into with_tz_types(d) values (select tltz from tz_test);
insert into with_tz_types(e) values (select tltz from tz_test);
insert into with_tz_types(f) values (select tltz from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from ttz constant value to date/time with time zone types
--BUG: CUBRIDSUS-16974, resolved
--BUG: CUBRIDSUS-17326
insert into with_tz_types(c) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(d) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(e) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(f) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from ttz column to date/time with time zone types
insert into with_tz_types(c) values (select ttz from tz_test);
insert into with_tz_types(d) values (select ttz from tz_test);
insert into with_tz_types(e) values (select ttz from tz_test);
insert into with_tz_types(f) values (select ttz from tz_test);
select * from with_tz_types order by id;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
