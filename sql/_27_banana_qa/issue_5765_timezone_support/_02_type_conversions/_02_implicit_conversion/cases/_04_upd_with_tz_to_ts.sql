--implicit conversion from with time zone types to TIMESTAMP(L)TZ types, in update

autocommit off;
drop table if exists tz_test, with_tz_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table with_tz_types(
        c timestamp with local time zone,
        d timestamp with time zone,
        e datetime with local time zone,
        f datetime with time zone
);
set timezone '+3:00';
insert into with_tz_types values(timestamptz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro',  datetimetz' 2019-12-10 3:40:56.299', datetimetz' 2019-12-10 3:40:56.299 Indian/Comoro');
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from with time zone constant values to ts types
update tz_test set ts=date'1999-09-09 -2:00', tsltz=date'1999-09-09 -2:00', tstz=date'1999-09-09 -2:00';
select * from tz_test order by 1;
update tz_test set ts=datetimetz'2015-9-17 22:22:22 +8:00', tsltz=datetimetz'2015-9-17 22:22:22 +8:00', tstz=datetimetz'2015-9-17 22:22:22 +8:00';
select * from tz_test order by 1;
rollback;
update tz_test set ts=timestamptz'1989-11-17 20:23:23 Australia/Eucla', tsltz=timestamptz'1989-11-17 20:23:23 Australia/Eucla', tstz=timestamptz'1989-11-17 20:23:23 Australia/Eucla';
select * from tz_test order by 1;
update tz_test set ts=datetimetz' 2010-10-23 05:59:59.456 America/Scoresbysund', tsltz=datetimetz' 2010-10-23 05:59:59.456 America/Scoresbysund', tstz=datetimetz' 2010-10-23 05:59:59.456 America/Scoresbysund';
select * from tz_test order by 1;
rollback;


--test: implicit conversion from with time zone types to ts types
update tz_test set ts=(select c from with_tz_types), tsltz=(select c from with_tz_types), tstz=(select c from with_tz_types);
select * from tz_test order by 1;
rollback;
update tz_test set ts=(select d from with_tz_types), tsltz=(select d from with_tz_types), tstz=(select d from with_tz_types);
select * from tz_test order by 1;
update tz_test set ts=(select e from with_tz_types), tsltz=(select e from with_tz_types), tstz=(select e from with_tz_types);
update tz_test set ts=(select f from with_tz_types), tsltz=(select f from with_tz_types), tstz=(select f from with_tz_types);
select * from tz_test order by 1;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
