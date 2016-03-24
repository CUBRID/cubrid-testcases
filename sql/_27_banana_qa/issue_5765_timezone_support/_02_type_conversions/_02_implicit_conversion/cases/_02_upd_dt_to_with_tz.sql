--implicit conversion from DATETIME(L)TZ columns to date/time with time zone types, in update

autocommit off;

drop table if exists tz_test, with_tz_types;

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
set timezone '+3:00';
insert into with_tz_types(c, d, e, f) values(timestampltz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro',datetimeltz' 2019-12-10 3:40:56.999',datetimetz' 2019-12-10 3:40:56.999 Indian/Comoro');
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from dt constant value to date/time with time zone types
update with_tz_types set c=datetime'1980-10-01 2:00:00.999';
update with_tz_types set d=datetime'1980-10-01 2:00:00.999';
update with_tz_types set e=datetime'1980-10-01 2:00:00.999';
update with_tz_types set f=datetime'1980-10-01 2:00:00.999';
select * from with_tz_types order by id; 
rollback;
--test: implicit conversion from dt column to date/time with time zone types
update with_tz_types set c=(select dt from tz_test);
update with_tz_types set d=(select dt from tz_test);
update with_tz_types set e=(select dt from tz_test);
update with_tz_types set f=(select dt from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from dtltz constant value to date/time with time zone types
update with_tz_types set c=datetimeltz' 1980-10-01 2:00:00.999 -5:00';
update with_tz_types set d=datetimeltz' 1980-10-01 2:00:00.999 -5:00';
update with_tz_types set e=datetimeltz' 1980-10-01 2:00:00.999 -5:00';
update with_tz_types set f=datetimeltz' 1980-10-01 2:00:00.999 -5:00';
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from dtltz column to date/time with time zone types
update with_tz_types set c=(select dtltz from tz_test);
update with_tz_types set d=(select dtltz from tz_test);
update with_tz_types set e=(select dtltz from tz_test);
update with_tz_types set f=(select dtltz from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from dttz constant value to date/time with time zone types
update with_tz_types set c=datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update with_tz_types set d=datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update with_tz_types set e=datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update with_tz_types set f=datetimetz' 1980-10-01 2:00:00.999 America/Argentina/Jujuy';
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from dttz column to date/time with time zone types
update with_tz_types set c=(select dttz from tz_test);
update with_tz_types set d=(select dttz from tz_test);
update with_tz_types set e=(select dttz from tz_test);
update with_tz_types set f=(select dttz from tz_test);
select * from with_tz_types order by id;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
