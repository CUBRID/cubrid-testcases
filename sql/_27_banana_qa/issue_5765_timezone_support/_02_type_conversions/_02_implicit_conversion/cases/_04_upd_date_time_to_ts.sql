--implicit conversion from date/time types to TIMESTAMP(L)TZ types, in update


drop table if exists tz_test, date_time_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table date_time_types(a date, b time, c timestamp, d datetime);
insert into date_time_types values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.299');

set timezone 'Asia/Seoul';
--test: implicit conversion from date/time constant values to ts types
update tz_test set ts=date'1999-09-09', tsltz=date'1999-09-09', tstz=date'1999-09-09';
select * from tz_test order by 1;
update tz_test set ts=time'22:22:22', tsltz=time'22:22:22', tstz=time'22:22:22';
select * from tz_test order by 1;
update tz_test set ts=timestamp'1989-11-17 20:23:23', tsltz=timestamp'1989-11-17 20:23:23', tstz=timestamp'1989-11-17 20:23:23';
select * from tz_test order by 1;
update tz_test set ts=datetime'2010-10-23 05:59:59.456', tsltz=datetime'2010-10-23 05:59:59.456', tstz=datetime'2010-10-23 05:59:59.456';
select * from tz_test order by 1;


--test: implicit conversion from date/time types to ts types
update tz_test set ts=(select a from date_time_types), tsltz=(select a from date_time_types), tstz=(select a from date_time_types);
select * from tz_test order by 1;
update tz_test set ts=(select b from date_time_types), tsltz=(select b from date_time_types), tstz=(select b from date_time_types);
select * from tz_test order by 1;
update tz_test set ts=(select c from date_time_types), tsltz=(select c from date_time_types), tstz=(select c from date_time_types);
select * from tz_test order by 1;
update tz_test set ts=(select d from date_time_types), tsltz=(select d from date_time_types), tstz=(select d from date_time_types);
select * from tz_test order by 1;


drop table tz_test, date_time_types;

set timezone 'Asia/Seoul';
