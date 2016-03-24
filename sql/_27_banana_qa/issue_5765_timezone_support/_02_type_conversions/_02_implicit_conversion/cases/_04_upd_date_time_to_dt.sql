--implicit conversion from date/time types to DATETIME(L)TZ types, in update


drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table date_time_types(a date, b time, c timestamp, d datetime);
insert into date_time_types values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.999');

set timezone 'Asia/Seoul';
--test: implicit conversion from date/time constant values to ts types
update tz_test set ts=date'1999-09-09', dtltz=date'1999-09-09', dttz=date'1999-09-09';
select * from tz_test order by 1;
update tz_test set ts=time'22:22:22', dtltz=time'22:22:22', dttz=time'22:22:22';
select * from tz_test order by 1;
update tz_test set ts=timestamp'1989-11-17 20:23:23', dtltz=timestamp'1989-11-17 20:23:23', dttz=timestamp'1989-11-17 20:23:23';
select * from tz_test order by 1;
update tz_test set ts=datetime'2010-10-23 05:59:59.999', dtltz=datetime'2010-10-23 05:59:59.999', dttz=datetime'2010-10-23 05:59:59.999';
select * from tz_test order by 1;


--test: implicit conversion from date/time types to ts types
update tz_test set ts=(select a from date_time_types), dtltz=(select a from date_time_types), dttz=(select a from date_time_types);
select * from tz_test order by 1;
update tz_test set ts=(select b from date_time_types), dtltz=(select b from date_time_types), dttz=(select b from date_time_types);
select * from tz_test order by 1;
update tz_test set ts=(select c from date_time_types), dtltz=(select c from date_time_types), dttz=(select c from date_time_types);
select * from tz_test order by 1;
update tz_test set ts=(select d from date_time_types), dtltz=(select d from date_time_types), dttz=(select d from date_time_types);
select * from tz_test order by 1;


drop table tz_test, date_time_types;

set timezone 'Asia/Seoul';
