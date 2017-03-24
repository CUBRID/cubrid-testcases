--test subdate/date_sub functions with DATETIME(L)TZ columns as argumendt
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

drop table if exists tz_test;

create table tz_test(id int, dt datetime, dtltz datetime with local time zone, dttz datetime with time zone);

--test: normal values
insert into tz_test values(1, datetimeltz'2014-03-01 12:00:00.999 AM -8:00', datetimeltz'2014-03-01 12:00:00.999 AM -8:00', datetimetz'2014-03-01 12:00:00.999 AM -8:00');
select if(subdate(dt, interval 1000 millisecond)=datetimeltz'2014-02-28 23:59:59.999 -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(subdate(dtltz, interval 1000 millisecond)=datetimeltz'2014-02-28 23:59:59.999 -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(subdate(dttz, interval 1000 millisecond)=datetimeltz'2014-02-28 23:59:59.999 -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 

insert into tz_test values(2, datetimeltz'2014-03-01 12:00:00.999 AM Asia/Shanghai', datetimeltz'2014-03-01 12:00:00.999 AM Asia/Shanghai', datetimetz'2014-03-01 12:00:00.999 AM Asia/Shanghai');
select if(subdate(dt, interval 1 second)=datetimeltz'2014-02-28 23:59:59.999 +8:00', 'ok', 'nok') from tz_test where id=2 order by 1; 
select if(subdate(dtltz, interval 1 second)=datetimeltz'2014-02-28 23:59:59.999 +8:00', 'ok', 'nok') from tz_test where id=2 order by 1; 
select if(subdate(dttz, interval 1 second)=datetimeltz'2014-02-28 23:59:59.999 +8:00', 'ok', 'nok') from tz_test where id=2 order by 1; 

insert into tz_test values(3, datetimeltz'2014-03-01 12:00:00.999 AM +9:00', datetimeltz'2014-03-01 12:00:00.999 AM +9:00', datetimetz'2014-03-01 12:00:00.999 AM +9:00');
select if(subdate(dt, interval 10 minute)=datetimeltz'2014-02-28 23:50:00.999', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(subdate(dtltz, interval 10 minute)=datetimeltz'2014-02-28 23:50:00.999', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(subdate(dttz, interval 10 minute)=datetimeltz'2014-02-28 23:50:00.999', 'ok', 'nok') from tz_test where id=3 order by 1; 

insert into tz_test values(4, datetimeltz'2014-02-28 20:00:00.999 -9:00', datetimeltz'2014-02-28 20:00:00.999 -9:00', datetimetz'2014-02-28 20:00:00.999 -9:00');
select if(subdate(dt, interval 5 hour)=datetimeltz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(subdate(dtltz, interval 5 hour)=datetimeltz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(subdate(dttz, interval 5 hour)=datetimeltz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 

insert into tz_test values(5, datetimeltz'2014-03-01 12:00:00.999 AM -5:00', '2014-03-01 12:00:00.999 AM -5:00', '2014-03-01 12:00:00.999 AM -5:00');
select if(subdate(dt, interval 1 day)=datetimeltz'2014-02-28 12:00:00.999 AM America/New_York', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(subdate(dtltz, interval 1 day)=datetimeltz'2014-02-28 12:00:00.999 AM America/New_York', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(subdate(dttz, interval 1 day)=datetimeltz'2014-02-28 12:00:00.999 AM America/New_York', 'ok', 'nok') from tz_test where id=5 order by 1; 

insert into tz_test values(6, datetimeltz'2014-03-14 11:59:59.999 PM Asia/Pyongyang', datetimeltz'2014-03-14 11:59:59.999 PM Asia/Pyongyang', datetimetz'2014-03-14 11:59:59.999 PM Asia/Pyongyang');
select if(subdate(dt, interval 2 week)=datetimeltz'2014-02-28 23:59:59.999', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(subdate(dtltz, interval 2 week)=datetimeltz'2014-02-28 23:59:59.999', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(subdate(dttz, interval 2 week)=datetimeltz'2014-02-28 23:59:59.999', 'ok', 'nok') from tz_test where id=6 order by 1; 

insert into tz_test values(7, datetimeltz'2014-12-28 23:59:59.999', datetimeltz'2014-12-28 23:59:59.999', datetimetz'2014-12-28 23:59:59.999');
select if(subdate(dt, interval 10 month)=datetimeltz'2014-2-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(subdate(dtltz, interval 10 month)=datetimeltz'2014-2-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(subdate(dttz, interval 10 month)=datetimeltz'2014-2-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok') from tz_test where id=7 order by 1; 

insert into tz_test values(8, datetimeltz'2015-02-28 15:59:59.999 -8:00', datetimeltz'2015-02-28 15:59:59.999 -8:00', datetimetz'2015-02-28 15:59:59.999 -8:00');
select if(subdate(dt, interval 12 quarter)=datetime'2012-03-01 8:59:59.999', 'ok', 'nok') from tz_test where id=8 order by 1; 
--BUG: CUBRIDSUS-17258
select if(subdate(dtltz, interval 12 quarter)=datetimeltz'2012-02-28 23:59:59.999 +0:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(subdate(dttz, interval 12 quarter)=datetimeltz'2012-02-28 23:59:59.999 +0:00', 'ok', 'nok') from tz_test where id=8 order by 1; 

insert into tz_test values(9, datetimeltz'2021-02-27 22:00:00.999 -10:00', datetimeltz'2021-02-27 22:00:00.999 -10:00', datetimetz'2021-02-27 22:00:00.999 -10:00');
select if(subdate(dt, interval 7 year)=datetimeltz'2014-02-28 12:00:00.999 AM -8:00', 'ok', 'nok') from tz_test where id=9 order by 1; 
select if(subdate(dtltz, interval 7 year)=datetimeltz'2014-02-28 12:00:00.999 AM -8:00', 'ok', 'nok') from tz_test where id=9 order by 1; 
select if(subdate(dttz, interval 7 year)=datetimeltz'2014-02-28 12:00:00.999 AM -8:00', 'ok', 'nok') from tz_test where id=9 order by 1; 

--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00

insert into tz_test values(10, '2008-10-20 13:58:59.999', '2008-10-20 13:58:59.999', '2008-10-20 13:58:59.999');
select if(date_sub(dt, interval '-1:1' minute_second)=datetimeltz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok') from tz_test where id=10 order by 1;
select if(date_sub(dtltz, interval '-1:1' minute_second)=datetimeltz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok') from tz_test where id=10 order by 1;
select if(date_sub(dttz, interval '-1:1' minute_second)=datetimeltz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok') from tz_test where id=10 order by 1;

insert into tz_test values(11, '2008-10-20 13:00:00.999', '2008-10-20 13:00:00.999', '2008-10-20 13:00:00.999');
select if(date_sub(dt, interval '1:1' minute_second)=datetimeltz'2008-10-20 14:58:59.999 UTC', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_sub(dtltz, interval '1:1' minute_second)=datetimeltz'2008-10-20 14:58:59.999 UTC', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_sub(dttz, interval '1:1' minute_second)=datetimeltz'2008-10-20 14:58:59.999 UTC', 'ok', 'nok') from tz_test where id=11 order by 1;

insert into tz_test values(12, '2008-10-19 1:00:00.999 am', '2008-10-19 1:00:00.999 am', '2008-10-19 1:00:00.999 am');
select if(date_sub(dt, interval '1:1' hour_minute)=datetimeltz'2008-10-18 23:59:00.999', 'ok', 'nok') from tz_test where id=12 order by 1;
--BUG: CUBRIDSUS-17258
select if(date_sub(dtltz, interval '1:1' hour_minute)=datetimeltz'2008-10-18 22:59:00.999 -3:00', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_sub(dttz, interval '1:1' hour_minute)=datetimeltz'2008-10-18 22:59:00.999 -3:00', 'ok', 'nok') from tz_test where id=12 order by 1;

insert into tz_test values(13, datetimeltz'2008-10-19 4:00:00.999 AM America/Argentina/Tucuman', '2008-10-19 4:00:00.999 AM America/Argentina/Tucuman', '2008-10-19 4:00:00.999 AM America/Argentina/Tucuman');
select if(date_sub(dt, interval '1 5:30:30.999' day_second)='2008-10-17 22:29:30.999', 'ok', 'nok') from tz_test where id=13 order by 1;
--BUG: CUBRIDSUS-17258
select if(date_sub(dtltz, interval '1 5:30:30.999' day_second)='2008-10-17 21:29:30.999', 'ok', 'nok') from tz_test where id=13 order by 1;
select if(date_sub(dttz, interval '1 5:30:30.999' day_second)='2008-10-17 21:29:30.999', 'ok', 'nok') from tz_test where id=13 order by 1;

insert into tz_test values(14, datetimeltz'2008-10-19 22:30:00.999', datetimeltz'2008-10-19 22:30:00.999', datetimetz'2008-10-19 22:30:00.999');
select if(date_sub(dt, interval '2-1' year_month)='2006-9-19 22:30:00.999', 'ok', 'nok') from tz_test where id=14 order by 1;
select if(date_sub(dtltz, interval '2-1' year_month)='2006-9-19 21:30:00.999', 'ok', 'nok') from tz_test where id=14 order by 1;
select if(date_sub(dttz, interval '2-1' year_month)='2006-9-19 21:30:00.999', 'ok', 'nok') from tz_test where id=14 order by 1;


insert into tz_test values(15, '2009-3-14 21:59:59.999', '2009-3-14 21:59:59.999', '2009-3-14 21:59:59.999');
select if(subdate(dt, interval '-2:00:00.001' hour_millisecond)=datetimetz'2009-3-15 12:00:00 AM America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=15 order by 1;
--BUG: CUBRIDSUS-17263, resolved
--BUG: CUBRIDSUS-17332
select if(subdate(dtltz, interval '-2:00:00.001' hour_millisecond)=datetimetz'2009-3-14 23:00:00 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=15 order by 1;
select if(subdate(dttz, interval '-2:00:00.001' hour_millisecond)=datetimetz'2009-3-14 23:00:00 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=15 order by 1;

insert into tz_test values(16, '2009-3-15 12:30:01.999 AM', '2009-3-15 12:30:01.999 AM', '2009-3-15 12:30:01.999 AM');
select subdate(dt, interval '1:00:01.999' hour_millisecond) from tz_test where id=16 order by 1;
select subdate(dtltz, interval '1:00:01.999' hour_millisecond) from tz_test where id=16 order by 1;
select subdate(dttz, interval '1:00:01.999' hour_millisecond) from tz_test where id=16 order by 1;

select if(subdate(dt, interval '1:00:01' hour_second)=datetimetz'2009-3-14 11:30:00.999 PM America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(dtltz, interval '1:00:01' hour_second)=datetimetz'2009-3-14 11:30:00.999 PM America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(dttz, interval '1:00:01' hour_second)=datetimetz'2009-3-14 11:30:00.999 PM America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=16 order by 1;

select if(subdate(dt, interval '2:00:01' hour_second)=datetimetz'2009-3-14 10:30:00.999 PM America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(dtltz, interval '2:00:01' hour_second)=datetimetz'2009-3-14 11:30:00.999 PM America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(dttz, interval '2:00:01' hour_second)=datetimetz'2009-3-14 11:30:00.999 PM America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=16 order by 1;

select if(subdate(dt, interval '3:00:01.999' hour_millisecond)='2009-3-14 09:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(dtltz, interval '3:00:01.999' hour_millisecond)='2009-3-14 10:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(dttz, interval '3:00:01.999' hour_millisecond)='2009-3-14 10:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;

insert into tz_test values(17, datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03');
select if(subdate(dt, interval '1' hour)=datetimeltz'2009-3-14 22:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(subdate(dtltz, interval '1' hour)=datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(subdate(dttz, interval '1' hour)=datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=17 order by 1;

insert into tz_test values(18, datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03');
select if(subdate(dt, interval '1' hour)=datetimeltz'2009-3-14 22:11:12.999', 'ok', 'nok') from tz_test where id=18 order by 1;
select if(subdate(dtltz, interval '1' hour)=datetimeltz'2009-3-14 23:11:12.999', 'ok', 'nok') from tz_test where id=18 order by 1;
select if(subdate(dttz, interval '1' hour)=datetimeltz'2009-3-14 23:11:12.999', 'ok', 'nok') from tz_test where id=18 order by 1;

insert into tz_test values(19, datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03');
select if(subdate(dt, interval '1' hour)='2009-3-14 22:11:12.999 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(dtltz, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(dttz, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=19 order by 1;

select if(subdate(dt, interval '1' hour)='2009-3-14 22:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(dtltz, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(dttz, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=19 order by 1;

insert into tz_test values(20, '2009-3-15 12:11:12.999 AM', '2009-3-15 12:11:12.999 AM', '2009-3-15 12:11:12.999 AM');
select if(subdate(dt, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(dtltz, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(dttz, interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=20 order by 1;

select if(subdate(dt, interval '2' hour)='2009-3-14 22:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(dtltz, interval '2' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(dttz, interval '2' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=20 order by 1;

--[er]
insert into tz_test values(21, datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba KST', '2009-3-14 23:11:12.999 America/Argentina/Cordoba KST', '2009-3-14 23:11:12.999 America/Argentina/Cordoba KST');

--test: leap seconds
--bug: CUBRIDSUS-16595(by design)
--need to confirm whether datetimetz/timestamptz type both affected by leap second 
insert into tz_test values(22, '2008-12-31 21:59:59.999', '2008-12-31 21:59:59.999', '2008-12-31 21:59:59.999');
select if(date_sub(dt, interval '-1' second)=datetimeltz'2008-12-31 22:00:00.999', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(dtltz, interval '-1' second)=datetimeltz'2008-12-31 22:00:00.999', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(dttz, interval '-1' second)=datetimeltz'2008-12-31 22:00:00.999', 'ok', 'nok') from tz_test where id=22 order by 1;

select if(date_sub(dt, interval '1' second)=datetimeltz'2008-12-31 21:59:58.999', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(dtltz, interval '1' second)=datetimeltz'2008-12-31 21:59:58.999', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(dttz, interval '1' second)=datetimeltz'2008-12-31 21:59:58.999', 'ok', 'nok') from tz_test where id=22 order by 1;

select if(date_sub(dt, interval '-2' second)=datetimetz'2009-01-01 12:00:01.999 am UTC', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(dtltz, interval '-2' second)='2009-01-01 12:00:01.999 am UTC', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(dttz, interval '-2' second)='2009-01-01 12:00:01.999 am UTC', 'ok', 'nok') from tz_test where id=22 order by 1;

insert into tz_test values(23, datetimeltz'2008-12-31 21:00:00.999 America/Argentina/Cordoba', datetimeltz'2008-12-31 21:00:00.999 America/Argentina/Cordoba', datetimetz'2008-12-31 21:00:00.999 America/Argentina/Cordoba');
select if(date_sub(dt, interval '2' second)='2008-12-31 20:59:58.999', 'ok', 'nok') from tz_test where id=23 order by 1;
select if(date_sub(dtltz, interval '2' second)='2008-12-31 20:59:58.999', 'ok', 'nok') from tz_test where id=23 order by 1;
select if(date_sub(dttz, interval '2' second)='2008-12-31 20:59:58.999', 'ok', 'nok') from tz_test where id=23 order by 1;

insert into tz_test values(24, datetimeltz'2009-01-01 12:00:00.999 am UTC', datetimeltz'2009-01-01 12:00:00.999 am UTC', datetimetz'2009-01-01 12:00:00.999 am UTC');
select if(date_sub(dt, interval '1' second)='2008-12-31 21:59:59.999 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=24 order by 1;
select if(date_sub(dtltz, interval '2' second)='2008-12-31 21:59:58.999 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=24 order by 1;
select if(date_sub(dttz, interval '1:00:01.999' hour_second)=datetimeltz'2008-12-31 22:59:59.999 UTC', 'ok', 'nok') from tz_test where id=24 order by 1;
select if(date_sub(dttz, interval '1:00:02.999' hour_second)=datetimeltz'2008-12-31 22:59:58.999 UTC', 'ok', 'nok') from tz_test where id=24 order by 1;

--test: subdate
insert into tz_test values(25, datetimeltz'2008-10-19 23:59:00.999', datetimeltz'2008-10-19 23:59:00.999', datetimetz'2008-10-19 23:59:00.999');
select if(subdate(dt, 1)='2008-10-18 23:59:00.999', 'ok', 'nok') from tz_test where id=25 order by 1;
select if(subdate(dtltz, 1)='2008-10-18 22:59:00.999', 'ok', 'nok') from tz_test where id=25 order by 1;
select if(subdate(dttz, 1)='2008-10-18 22:59:00.999', 'ok', 'nok') from tz_test where id=25 order by 1;

insert into tz_test values(26, datetimeltz'2009-3-15 22:11:12.999 America/Argentina/Cordoba', '2009-3-15 22:11:12.999 America/Argentina/Cordoba', '2009-3-15 22:11:12.999 America/Argentina/Cordoba');
select if(subdate(dt, 1)=datetimeltz'2009-3-14 22:11:12.999', 'ok', 'nok') from tz_test where id=26 order by 1;
select if(subdate(dtltz, 1)=datetimeltz'2009-3-14 23:11:12.999', 'ok', 'nok') from tz_test where id=26 order by 1;
select if(subdate(dttz, 1)=datetimeltz'2009-3-14 23:11:12.999', 'ok', 'nok') from tz_test where id=26 order by 1;


drop table tz_test;
set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
