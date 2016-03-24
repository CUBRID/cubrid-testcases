--implicit conversion from with time zone types to TIME(L)TZ types, in update

autocommit off;
drop table if exists tz_test, with_tz_types;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

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
--test: implicit conversion from with time zone constant values to t types
update tz_test set t=date'2019-12-10', tltz=date'2019-12-10', ttz=date'2019-12-10';
select * from tz_test order by 1;
update tz_test set t=datetimetz'2015-9-17 22:22:22 +8:00', tltz=datetimetz'2015-9-17 22:22:22 +8:00', ttz=datetimetz'2015-9-17 22:22:22 +8:00';
select * from tz_test order by 1;
rollback;
update tz_test set t=timestamptz'1989-11-17 20:23:23 Australia/Eucla', tltz=timestamptz'1989-11-17 20:23:23 Australia/Eucla', ttz=timestamptz'1989-11-17 20:23:23 Australia/Eucla';
select * from tz_test order by 1;
update tz_test set t=datetimetz' 2019-12-10 05:59:59.456 America/Scoresbysund', tltz=datetimetz' 2019-12-10 05:59:59.456 America/Scoresbysund', ttz=datetimetz' 2019-12-10 05:59:59.456 America/Scoresbysund';
select * from tz_test order by 1;
rollback;


--test: implicit conversion from with time zone types to t types
update tz_test set t=(select c from with_tz_types), tltz=(select c from with_tz_types), ttz=(select c from with_tz_types);
select * from tz_test order by 1;
rollback;
update tz_test set t=(select d from with_tz_types), tltz=(select d from with_tz_types), ttz=(select d from with_tz_types);
select * from tz_test order by 1;
update tz_test set t=(select e from with_tz_types), tltz=(select e from with_tz_types), ttz=(select e from with_tz_types);
update tz_test set t=(select f from with_tz_types), tltz=(select f from with_tz_types), ttz=(select f from with_tz_types);
select * from tz_test order by 1;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
