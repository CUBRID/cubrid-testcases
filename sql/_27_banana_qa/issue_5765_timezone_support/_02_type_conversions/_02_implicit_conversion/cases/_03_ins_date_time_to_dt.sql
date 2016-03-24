--implicit conversion from date/time types to DATETIME(L)TZ types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';

create table date_time_types(a date, b time, c timestamp, d datetime);
insert into date_time_types values(date'2000-10-10', time'12:13:14', timestamp'2019-12-10 3:40:56', datetime'2019-12-10 3:40:56.999');

set timezone 'Asia/Seoul';
--test: implicit conversion from date/time constant values to ts types
insert into tz_test(ts, dtltz, dttz) values (date'1999-09-09', date'1999-09-09', date'1999-09-09');
insert into tz_test(ts, dtltz, dttz) values (time'22:22:22.999', time'22:22:22.999', time'22:22:22.999');
insert into tz_test(ts, dtltz, dttz) values (timestamp'1989-11-17 20:23:23', timestamp'1989-11-17 20:23:23', timestamp'1989-11-17 20:23:23');
insert into tz_test(ts, dtltz, dttz) values (datetime'2010-10-23 05:59:59.999', datetime'2010-10-23 05:59:59.999', datetime'2010-10-23 05:59:59.999');
select * from tz_test order by 1;


--test: implicit conversion from date/time types to ts types
insert into tz_test(ts, dtltz, dttz) values (select a from date_time_types, select a from date_time_types, select a from date_time_types);
insert into tz_test(ts, dtltz, dttz) values (select b from date_time_types, select b from date_time_types, select b from date_time_types);
insert into tz_test(ts, dtltz, dttz) values (select c from date_time_types, select c from date_time_types, select c from date_time_types);
insert into tz_test(ts, dtltz, dttz) values (select d from date_time_types, select d from date_time_types, select d from date_time_types);
select * from tz_test order by 1;


drop table tz_test, date_time_types;

set timezone 'Asia/Seoul';
