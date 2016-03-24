--implicit conversion from DATETIME(L)TZ columns to date/time with time zone types, in insert 

autocommit off;
drop table if exists tz_test;

create table tz_test (id int auto_increment, dt datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(dt, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999',datetimeltz' 1980-10-01 2:00:00.999',datetimetz' 1980-10-01 2:00:00.999 Asia/Yakutsk');

create table with_tz_types (
	id int auto_increment,
        c timestamp with local time zone,
        d timestamp with time zone,
        e datetime with local time zone,
        f datetime with time zone
);
commit;

set timezone '+9:00';
--test: implicit conversion from dt constant value to date/time with time zone types
insert into with_tz_types(c) values (datetime'1980-10-01 2:00:00.999');
insert into with_tz_types(d) values (datetime'1980-10-01 2:00:00.999');
insert into with_tz_types(e) values (datetime'1980-10-01 2:00:00.999');
insert into with_tz_types(f) values (datetime'1980-10-01 2:00:00.999');
select * from with_tz_types order by id; 
rollback;
--test: implicit conversion from dt column to date/time with time zone types
insert into with_tz_types(c) values (select dt from tz_test);
insert into with_tz_types(d) values (select dt from tz_test);
insert into with_tz_types(e) values (select dt from tz_test);
insert into with_tz_types(f) values (select dt from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from dtltz constant value to date/time with time zone types
insert into with_tz_types(c) values (datetimeltz' 1980-10-01 2:00:00.999 -5:00');
insert into with_tz_types(d) values (datetimeltz' 1980-10-01 2:00:00.999 -5:00');
insert into with_tz_types(e) values (datetimeltz' 1980-10-01 2:00:00.999 -5:00');
insert into with_tz_types(f) values (datetimeltz' 1980-10-01 2:00:00.999 -5:00');
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from dtltz column to date/time with time zone types
insert into with_tz_types(c) values (select dtltz from tz_test);
insert into with_tz_types(d) values (select dtltz from tz_test);
insert into with_tz_types(e) values (select dtltz from tz_test);
insert into with_tz_types(f) values (select dtltz from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from dttz constant value to date/time with time zone types
--BUG: CUBRIDSUS-16974, resolved
insert into with_tz_types(c) values (datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into with_tz_types(d) values (datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into with_tz_types(e) values (datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into with_tz_types(f) values (datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy');
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from dttz column to date/time with time zone types
--BUG: CUBRIDSUS-16974, resolved
insert into with_tz_types(c) values (select dttz from tz_test);
insert into with_tz_types(d) values (select dttz from tz_test);
insert into with_tz_types(e) values (select dttz from tz_test);
insert into with_tz_types(f) values (select dttz from tz_test);
select * from with_tz_types order by id;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
