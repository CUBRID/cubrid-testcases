--implicit conversion from TIMESTAMP(L)TZ columns to date/time with time zone types, in update

autocommit off;

drop table if exists tz_test, with_tz_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table with_tz_types (
	id int auto_increment,
        c timestamp with local time zone,
        d timestamp with time zone,
        e datetime with local time zone,
        f datetime with time zone
);
set timezone '+3:00';
insert into with_tz_types(c, d, e, f) values(timestampltz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro', datetimeltz'2019-12-10 3:40:56.299', datetimetz'2019-12-10 3:40:56.299 Indian/Comoro');
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time with time zone types
update with_tz_types set c=timestamp'1980-10-01 2:00:00';
update with_tz_types set d=timestamp'1980-10-01 2:00:00';
update with_tz_types set e=timestamp'1980-10-01 2:00:00';
update with_tz_types set f=timestamp'1980-10-01 2:00:00';
select * from with_tz_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time with time zone types
update with_tz_types set c=(select ts from tz_test);
update with_tz_types set d=(select ts from tz_test);
update with_tz_types set e=(select ts from tz_test);
update with_tz_types set f=(select ts from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from tsltz constant value to date/time with time zone types
update with_tz_types set c=timestampltz'1980-10-01 2:00:00 -5:00';
update with_tz_types set d=timestampltz'1980-10-01 2:00:00 -5:00';
update with_tz_types set e=timestampltz'1980-10-01 2:00:00 -5:00';
update with_tz_types set f=timestampltz'1980-10-01 2:00:00 -5:00';
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from tsltz column to date/time with time zone types
update with_tz_types set c=(select tsltz from tz_test);
update with_tz_types set d=(select tsltz from tz_test);
update with_tz_types set e=(select tsltz from tz_test);
update with_tz_types set f=(select tsltz from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from tstz constant value to date/time with time zone types
update with_tz_types set c=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update with_tz_types set d=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update with_tz_types set e=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update with_tz_types set f=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from tstz column to date/time with time zone types
update with_tz_types set c=(select tstz from tz_test);
update with_tz_types set d=(select tstz from tz_test);
update with_tz_types set e=(select tstz from tz_test);
update with_tz_types set f=(select tstz from tz_test);
select * from with_tz_types order by id;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
