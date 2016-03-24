--implicit conversion from date/time types to TIME(L)TZ types, in update


drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table date_time_types(a date, b time, c timestamp, d datetime);
insert into date_time_types values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.299');

set timezone '+9:00';
--test: implicit conversion from date/time constant values to t types
update tz_test set t=date'1999-09-09', tltz=date'1999-09-09', ttz=date'1999-09-09';
select * from tz_test order by 1;
update tz_test set t=time'22:22:22', tltz=time'22:22:22', ttz=time'22:22:22';
select * from tz_test order by 1;
update tz_test set t=timestamp'1989-11-17 20:23:23', tltz=timestamp'1989-11-17 20:23:23', ttz=timestamp'1989-11-17 20:23:23';
select * from tz_test order by 1;
update tz_test set t=datetime'2010-10-23 05:59:59.456', tltz=datetime'2010-10-23 05:59:59.456', ttz=datetime'2010-10-23 05:59:59.456';
select * from tz_test order by 1;


--test: implicit conversion from date/time types to t types
update tz_test set t=(select a from date_time_types), tltz=(select a from date_time_types), ttz=(select a from date_time_types);
select * from tz_test order by 1;
update tz_test set t=(select b from date_time_types), tltz=(select b from date_time_types), ttz=(select b from date_time_types);
select * from tz_test order by 1;
update tz_test set t=(select c from date_time_types), tltz=(select c from date_time_types), ttz=(select c from date_time_types);
select * from tz_test order by 1;
update tz_test set t=(select d from date_time_types), tltz=(select d from date_time_types), ttz=(select d from date_time_types);
select * from tz_test order by 1;


drop table tz_test, date_time_types;

set timezone 'Asia/Seoul';
