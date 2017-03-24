--test adddate/date_add functions with DATETIME(L)TZ columns as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

drop table if exists tz_test;

create table tz_test(id int, dt datetime, dtltz datetime with local time zone, dttz datetime with time zone);

--test: normal values
insert into tz_test values(1, datetimeltz'2014-02-28 23:59:59.999 -8:00', '2014-02-28 23:59:59.999 -8:00', '2014-02-28 23:59:59.999 -8:00');
select if(adddate(dt, interval 1000 millisecond)=datetimetz'2014-03-01 12:00:00.999 AM -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(adddate(dtltz, interval 1000 millisecond)=datetimeltz'2014-03-01 12:00:00.999 AM -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(adddate(dttz, interval 1000 millisecond)=datetimetz'2014-03-01 12:00:00.999 AM -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 

insert into tz_test values(2, datetimetz'2014-02-28 23:59:59.999 Asia/Shanghai', '2014-02-28 23:59:59.999 Asia/Shanghai', '2014-02-28 23:59:59.999 Asia/Shanghai');
select if(adddate(dt, interval 1 second)=datetimetz'2014-03-01 12:00:00.999 AM', 'ok', 'nok') from tz_test where id=2 order by 1;
select if(adddate(dtltz, interval 1 second)=datetimetz'2014-03-01 12:00:00.999 AM +8:00', 'ok', 'nok') from tz_test where id=2 order by 1;
select if(adddate(dttz, interval 1 second)=datetimetz'2014-03-01 12:00:00.999 AM +8:00', 'ok', 'nok') from tz_test where id=2 order by 1;

insert into tz_test values(3, datetimetz'2014-02-28 23:50:00.999', datetimetz'2014-02-28 23:50:00.999', datetimetz'2014-02-28 23:50:00.999'); 
select if(adddate(dt, interval 10 minute)=datetimeltz'2014-03-01 12:00:00.999 AM +9:00', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(adddate(dttz, interval 10 minute)=datetimetz'2014-03-01 12:00:00.999 AM +9:00', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(adddate(dtltz, interval 10 minute)=datetimeltz'2014-03-01 12:00:00.999 AM +9:00', 'ok', 'nok') from tz_test where id=3 order by 1; 

insert into tz_test values(4, datetimeltz'2014-02-28 20:00:00.999 -9:00', '2014-02-28 20:00:00.999 -9:00', '2014-02-28 20:00:00.999 -9:00');
select if(adddate(dt, interval -5 hour)=datetimeltz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(adddate(dtltz, interval -5 hour)=datetimetz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(adddate(dttz, interval -5 hour)=datetimetz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 

insert into tz_test values(5, datetimetz'2014-02-28 12:00:00.999 AM America/New_York', '2014-02-28 12:00:00.999 AM America/New_York', '2014-02-28 12:00:00.999 AM America/New_York');
select if(adddate(dt, interval 1 day)=datetimetz'2014-03-01 12:00:00.999 AM', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(adddate(dtltz, interval 1 day)=datetimeltz'2014-03-01 12:00:00.999 AM -5:00', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(adddate(dttz, interval 1 day)=datetimetz'2014-03-01 12:00:00.999 AM -5:00', 'ok', 'nok') from tz_test where id=5 order by 1; 

insert into tz_test values(6, datetimetz'2014-02-28 23:59:59.999', datetimetz'2014-02-28 23:59:59.999', datetimetz'2014-02-28 23:59:59.999');
select if(adddate(dtltz, interval 2 week)=datetimetz'2014-03-14 11:59:59.999 PM Asia/Pyongyang', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(adddate(dt, interval 10 month)=datetimetz'2014-12-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(adddate(dttz, interval 10 month)=datetimeltz'2014-12-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok') from tz_test where id=6 order by 1; 

insert into tz_test values(7, datetimeltz'2012-02-29 23:59:59.999 +0:00', '2012-02-29 23:59:59.999 +0:00', '2012-02-29 23:59:59.999 +0:00');
select if(adddate(dt, interval 12 quarter)=datetimeltz'2015-02-28 15:59:59.999 -8:00', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(adddate(dtltz, interval 12 quarter)=datetimetz'2015-02-28 15:59:59.999 -8:00', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(adddate(dttz, interval 12 quarter)=datetimetz'2015-02-28 15:59:59.999 -8:00', 'ok', 'nok') from tz_test where id=7 order by 1; 

insert into tz_test values(8, datetimeltz'2012-02-29 12:00:00.999 AM -8:00', '2012-02-29 12:00:00.999 AM -8:00', '2012-02-29 12:00:00.999 AM -8:00');
select if(adddate(dt, interval 9 year)=datetimetz'2021-02-27 22:00:00.999 -10:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(adddate(dtltz, interval 9 year)=datetimeltz'2021-02-27 22:00:00.999 -10:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(adddate(dttz, interval 9 year)=datetimetz'2021-02-27 22:00:00.999 -10:00', 'ok', 'nok') from tz_test where id=8 order by 1; 


--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00

insert into tz_test values(9, datetimeltz'2008-10-20 13:58:59.999', '2008-10-20 13:58:59.999', '2008-10-20 13:58:59.999');
select if(date_add(dt, interval '1:1' minute_second)=datetimetz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok') from tz_test where id=9 order by 1;
select if(date_add(dtltz, interval '1:1' minute_second)=datetimetz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok') from tz_test where id=9 order by 1;
select if(date_add(dttz, interval '1:1' minute_second)=datetimeltz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok') from tz_test where id=9 order by 1;

insert into tz_test values(10, datetimetz'2008-10-18 22:59:00.999 -3:00', '2008-10-18 22:59:00.999 -3:00', '2008-10-18 22:59:00.999 -3:00');
--[er] non-existent value
select if(date_add(dt, interval '1:1' hour_minute)=datetimeltz'2008-10-19 1:00:00.999 am', 'ok', 'nok') from tz_test where id=10 order by 1;
--BUG: CUBRIDSUS-17265, resolved
--BUG: CUBRIDSUS-17298
select if(date_add(dtltz, interval '1:1' hour_minute)=datetimetz'2008-10-19 1:00:00.999 am', 'ok', 'nok') from tz_test where id=10 order by 1;
select if(date_add(dttz, interval '1:1' hour_minute)=datetimetz'2008-10-19 1:00:00.999 am', 'ok', 'nok') from tz_test where id=10 order by 1;

--BUG: CUBRIDSUS-15181, resolved
insert into tz_test values(11, datetimeltz'2008-10-17 21:30:00.999 America/Argentina/Tucuman', '2008-10-17 21:30:00.999 America/Argentina/Tucuman', '2008-10-17 21:30:00.999 America/Argentina/Tucuman'); 
select if(date_add(dt, interval '1 5:30:00.999' day_second)='2008-10-19 3:00:00.999 AM', 'ok', 'nok') from tz_test where id=11 order by 1;
--BUG: CUBRIDSUS-17298
select if(date_add(dtltz, interval '1 5:30:00.999' day_second)='2008-10-19 4:00:00.999 AM', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_add(dttz, interval '1 5:30:00.999' day_second)='2008-10-19 4:00:00.999 AM', 'ok', 'nok') from tz_test where id=11 order by 1;

--BUG: CUBRIDSUS-15181, resolved
insert into tz_test values(12, datetimetz'2006-9-19 21:30:00.999', datetimetz'2006-9-19 21:30:00.999', datetimetz'2006-9-19 21:30:00.999');
select if(date_add(dt, interval '2-1' year_month)='2008-10-19 21:30:00.999', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_add(dtltz, interval '2-1' year_month)='2008-10-19 22:30:00.999', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_add(dttz, interval '2-1' year_month)='2008-10-19 22:30:00.999', 'ok', 'nok') from tz_test where id=12 order by 1;

insert into tz_test values(13, datetimeltz'2009-3-14 22:00:00.000', '2009-3-14 21:59:59.999', '2009-3-14 21:59:59.999');
--[error]??
select adddate(dt, interval '2:00:01.999' hour_second) from tz_test where id=13 order by 1;
select if(adddate(dtltz, interval '2:00:01.999' hour_second)=datetimetz'2009-3-14 11:00:00.999 PM America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=13 order by 1;
select if(adddate(dttz, interval '2:00:01.999' hour_second)=datetimetz'2009-3-14 11:00:00.999 PM America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=13 order by 1;

insert into tz_test values(14, datetimetz'2009-3-14 23:11:12.999', '2009-3-14 23:11:12.999', '2009-3-14 23:11:12.999');
--BUG: CUBRIDSUS-17263, resolved
--BUG: CUBRIDSUS-17332
select if(adddate(dttz, interval '1' hour)=datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=14 order by 1;
select if(adddate(dtltz, interval '1' hour)=datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=14 order by 1;
select if(adddate(dt, interval '1' hour)=(datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03'+3600000), 'ok', 'nok') from tz_test where id=14 order by 1;

insert into tz_test values(15, datetimeltz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', '2009-3-14 23:11:12.999 America/Argentina/Cordoba -03');
select if(adddate(dt, interval '1' hour)='2009-3-15 00:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=15 order by 1;
select if(adddate(dtltz, interval '1' hour)=(datetimetz'2009-3-15 12:11:12.999 AM' - 3600000), 'ok', 'nok') from tz_test where id=15 order by 1;
select if(adddate(dttz, interval '1' hour)='2009-3-15 12:11:12.999 AM', 'ok', 'nok') from tz_test where id=15 order by 1;

--test: leap seconds
insert into tz_test values(16, datetimetz'2008-12-31 22:00:00.000', '2008-12-31 21:59:59.999', '2008-12-31 21:59:59.999');
select if(date_add(dt, interval '1' millisecond)=datetimeltz'2008-12-31 22:00:00.001', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(date_add(dtltz, interval '1' millisecond)=datetimetz'2008-12-31 22:00:00.000', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(date_add(dttz, interval '1' millisecond)=datetimetz'2008-12-31 22:00:00.000', 'ok', 'nok') from tz_test where id=16 order by 1;

insert into tz_test values(17, datetimetz'2008-12-31 22:00:00.999 America/Argentina/Cordoba', datetimetz'2008-12-31 21:59:59.999 America/Argentina/Cordoba', datetimetz'2008-12-31 21:59:59.999 America/Argentina/Cordoba');
select if(date_add(dt, interval '2' second)='2008-12-31 22:00:02.999 am', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(date_add(dtltz, interval '2' second)='2009-01-01 12:00:01.999 am UTC', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(date_add(dttz, interval '2' second)='2009-01-01 12:00:01.999 am UTC', 'ok', 'nok') from tz_test where id=17 order by 1;

insert into tz_test values(18, datetimeltz'2008-12-31 22:59:59.999 +00:00', '2008-12-31 22:59:59.999 +00:00', '2008-12-31 22:59:59.999 +00:00');
select if(date_add(dt, interval '1:00:00.001' hour_millisecond)=datetimetz'2008-12-31 22:00:00.000 PM', 'ok', 'nok') from tz_test where id=18 order by 1;
select if(date_add(dtltz, interval '1:00:00.001' hour_millisecond)=datetimetz'2009-1-1 12:00:00.000 AM UTC', 'ok', 'nok') from tz_test where id=18 order by 1;
select if(date_add(dttz, interval '1:00:00.001' hour_millisecond)=datetimeltz'2009-1-1 12:00:00.000 AM UTC', 'ok', 'nok') from tz_test where id=18 order by 1;

insert into tz_test values(19, datetimeltz'2008-12-31 22:59:59.999 UTC', '2008-12-31 22:59:59.999 UTC', '2008-12-31 22:59:59.999 UTC');
select if(date_add(dt, interval '1:00:00.001' hour_millisecond)='2008-12-31 22:00:00 UTC', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(date_add(dtltz, interval '1:00:00.001' hour_millisecond)='2009-01-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(date_add(dttz, interval '1:00:00.001' hour_millisecond)='2009-01-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=19 order by 1;

--test: adddate
insert into tz_test values(20, datetimetz'2008-10-18 22:59:00.999', datetimeltz'2008-10-18 22:59:00.999', datetimetz'2008-10-18 22:59:00.999');
select * from tz_test where id=20;
--BUG: CUBRIDSUS-17297
select if(adddate(dt, 1)='2008-10-19 22:59:00.999', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(adddate(dtltz, 1)='2008-10-19 23:59:00.999', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(adddate(dttz, 1)='2008-10-19 23:59:00.999', 'ok', 'nok') from tz_test where id=20 order by 1;

insert into tz_test values(21, datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba', '2009-3-14 23:11:12.999 America/Argentina/Cordoba', '2009-3-14 23:11:12.999 America/Argentina/Cordoba');
select if(adddate(dt, 1)=datetimetz'2009-3-15 23:11:12.999', 'ok', 'nok') from tz_test where id=21 order by 1;
select if(adddate(dtltz, 1)=datetimetz'2009-3-15 22:11:12.999', 'ok', 'nok') from tz_test where id=21 order by 1;
select if(adddate(dttz, 1)=datetimetz'2009-3-15 22:11:12.999', 'ok', 'nok') from tz_test where id=21 order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
