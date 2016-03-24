--implicit conversion from TIMESTAMP(L)TZ columns to date/time with time zone types, in insert 

autocommit off;
drop table if exists tz_test;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table with_tz_types (
	id int auto_increment,
        a datetime with local time zone,
        b datetime with time zone,
        c timestamp with local time zone,
        d timestamp with time zone,
        e datetime with local time zone,
        f datetime with time zone
);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from ts constant value to date/time with time zone types
insert into with_tz_types(a) values (timestamp'1980-10-01 2:00:00');
insert into with_tz_types(b) values (timestamp'1980-10-01 2:00:00');
insert into with_tz_types(c) values (timestamp'1980-10-01 2:00:00');
insert into with_tz_types(d) values (timestamp'1980-10-01 2:00:00');
insert into with_tz_types(e) values (timestamp'1980-10-01 2:00:00');
insert into with_tz_types(f) values (timestamp'1980-10-01 2:00:00');
select * from with_tz_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time with time zone types
insert into with_tz_types(a) values (select ts from tz_test);
insert into with_tz_types(b) values (select ts from tz_test);
insert into with_tz_types(c) values (select ts from tz_test);
insert into with_tz_types(d) values (select ts from tz_test);
insert into with_tz_types(e) values (select ts from tz_test);
insert into with_tz_types(f) values (select ts from tz_test);
--BUG: CUBRIDSUS-15152, resolved
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from tsltz constant value to date/time with time zone types
insert into with_tz_types(a) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into with_tz_types(b) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into with_tz_types(c) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into with_tz_types(d) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into with_tz_types(e) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into with_tz_types(f) values (timestampltz'1980-10-01 2:00:00 -5:00');
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from tsltz column to date/time with time zone types
insert into with_tz_types(a) values (select tsltz from tz_test);
insert into with_tz_types(b) values (select tsltz from tz_test);
insert into with_tz_types(c) values (select tsltz from tz_test);
insert into with_tz_types(d) values (select tsltz from tz_test);
insert into with_tz_types(e) values (select tsltz from tz_test);
insert into with_tz_types(f) values (select tsltz from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from tstz constant value to date/time with time zone types
insert into with_tz_types(a) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
--BUG: CUBRIDSUS-16974, resolved
insert into with_tz_types(b) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(c) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(d) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(e) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into with_tz_types(f) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
--BUG: CUBRIDSUS-15041, resolved
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from tstz column to date/time with time zone types
insert into with_tz_types(a) values (select tstz from tz_test);
--BUG: CUBRIDSUS-16974, resolved
insert into with_tz_types(b) values (select tstz from tz_test);
insert into with_tz_types(c) values (select tstz from tz_test);
insert into with_tz_types(d) values (select tstz from tz_test);
insert into with_tz_types(e) values (select tstz from tz_test);
insert into with_tz_types(f) values (select tstz from tz_test);
select * from with_tz_types order by id;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
