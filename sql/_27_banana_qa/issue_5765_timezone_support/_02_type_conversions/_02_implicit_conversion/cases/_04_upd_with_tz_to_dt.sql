--implicit conversion from with time zone types to DATETIME(L)TZ types, in update

autocommit off;
drop table if exists tz_test, with_tz_types;

create table tz_test (id int auto_increment, dt datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(dt, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz' 1980-10-01 2:00:00.999', datetimetz' 1980-10-01 2:00:00.999 Asia/Yakutsk');

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
--test: implicit conversion from with time zone constant values to dt types
update tz_test set dt=date'1999-09-09', dtltz=date'1999-09-09', dttz=date'1999-09-09';
select * from tz_test order by 1;
update tz_test set dt=datetimetz'2015-9-17 22:22:22 +8:00', dtltz=datetimeltz'2015-9-17 22:22:22 +8:00', dttz=datetimetz'2015-9-17 22:22:22 +8:00';
select * from tz_test order by 1;
rollback;
update tz_test set dt=timestamptz'1989-11-17 20:23:23 Australia/Eucla', dtltz=timestamptz'1989-11-17 20:23:23 Australia/Eucla', dttz=timestamptz'1989-11-17 20:23:23 Australia/Eucla';
select * from tz_test order by 1;
update tz_test set dt=datetimetz' 2010-10-23 05:59:59.456 America/Scoresbysund', dtltz=datetimetz' 2010-10-23 05:59:59.456 America/Scoresbysund', dttz=datetimetz' 2010-10-23 05:59:59.456 America/Scoresbysund';
select * from tz_test order by 1;
rollback;


--test: implicit conversion from with time zone types to dt types
select * from tz_test order by 1;
update tz_test set dt=(select c from with_tz_types), dtltz=(select c from with_tz_types), dttz=(select c from with_tz_types);
select * from tz_test order by 1;
rollback;
update tz_test set dt=(select d from with_tz_types), dtltz=(select d from with_tz_types), dttz=(select d from with_tz_types);
select * from tz_test order by 1;
update tz_test set dt=(select e from with_tz_types), dtltz=(select e from with_tz_types), dttz=(select e from with_tz_types);
update tz_test set dt=(select f from with_tz_types), dtltz=(select f from with_tz_types), dttz=(select f from with_tz_types);
select * from tz_test order by 1;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
