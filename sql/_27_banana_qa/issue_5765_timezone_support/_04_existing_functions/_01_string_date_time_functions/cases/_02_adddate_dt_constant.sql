--test adddate/date_add functions with DATETIME(L)TZ constant values as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

--test: normal values
--BUG: CUBRIDSUS-15254, resolved
select if(adddate(datetimetz'2014-02-28 23:59:59.999 -8:00', interval 1000 millisecond)=datetimeltz'2014-03-01 12:00:00.999 AM -8:00', 'ok', 'nok'); 
select if(adddate(datetimeltz'2014-02-28 23:59:59.999 Asia/Shanghai', interval 1 second)=datetimeltz'2014-03-01 12:00:00.999 AM +8:00', 'ok', 'nok'); 
select if(adddate(datetimetz'2014-02-28 23:50:00.999', interval 10 minute)=datetimeltz'2014-03-01 12:00:00.999 AM +9:00', 'ok', 'nok'); 
select if(adddate(datetimeltz'2014-02-28 20:00:00.999 -9:00', interval -5 hour)=datetimeltz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok'); 
select if(adddate(datetimetz'2014-02-28 12:00:00.999 AM America/New_York', interval 1 day)=datetimeltz'2014-03-01 12:00:00.999 AM -5:00', 'ok', 'nok'); 
select if(adddate(datetimetz'2014-02-28 23:59:59.999', interval 2 week)=datetimeltz'2014-03-14 11:59:59.999 PM Asia/Pyongyang', 'ok', 'nok'); 
select if(adddate(datetimeltz'2014-02-28 23:59:59.999', interval 10 month)=datetimeltz'2014-12-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok'); 
select if(adddate(datetimetz'2012-02-29 23:59:59.999 +0:00', interval 12 quarter)=datetimeltz'2015-02-28 15:59:59.999 -8:00', 'ok', 'nok'); 
select if(adddate(datetimetz'2012-02-29 12:00:00.999 AM -8:00', interval 9 year)=datetimeltz'2021-02-27 22:00:00.999 -10:00', 'ok', 'nok'); 

--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00
--BUG: CUBRIDSUS-15166, resolved
select if(date_add('2008-10-20 13:58:59.999', interval '1:1' minute_second)=datetimetz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok');
select if(date_add('2008-10-18 22:59:00.999 -3:00', interval '1:1' hour_minute)=datetimetz'2008-10-19 1:00:00.999 am', 'ok', 'nok');
--BUG: CUBRIDSUS-17298
select if(date_add('2008-10-17 21:30:00.999 America/Argentina/Tucuman', interval '1 5:30:00.999' day_second)=datetimetz'2008-10-19 4:00:00.999 AM', 'ok', 'nok');
--BUG: CUBRIDSUS-15032, resolved
select if(date_add(datetimeltz'2006-9-18 21:30:00.999', interval '2-1' year_month)=datetimetz'2008-10-18 21:30:00.999', 'ok', 'nok');
select if(date_add(datetimetz'2006-9-18 21:30:00.999', interval '2-1' year_month)=datetimetz'2008-10-18 21:30:00.999', 'ok', 'nok');
--BUG: CUBRIDSUS-15181, resolved
select adddate('2009-3-14 21:59:59.999', interval '2:00:01.999' hour_second);
--BUG: CUBRIDSUS-17263, resolved
--BUG: CUBRIDSUS-17332
select if(adddate(datetimeltz'2009-3-14 21:59:59.999', interval '2:00:01.999' hour_second)='2009-3-14 11:00:00.999 PM America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate(datetimeltz'2009-3-14 23:11:12.999', interval '1' hour)=datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12.999 America/Argentina/Cordoba', interval '1' hour)=datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', interval '1' hour)=datetimetz'2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', interval '1' hour)=datetimetz'2009-3-15 12:11:12.999 AM', 'ok', 'nok');
--[er]
select if(adddate('2009-3-14 23:11:12.999 America/Argentina/Cordoba KST', interval '1' hour)=datetimetz'2009-3-15 12:11:12.999 AM', 'ok', 'nok');

--test: leap seconds
select if(date_add('2008-12-31 21:59:59.999', interval '1' millisecond)=datetimetz'2008-12-31 22:00:00', 'ok', 'nok');
select if(date_add(datetimetz'2008-12-31 21:59:59.999 America/Argentina/Cordoba', interval '2' second)='2009-01-01 12:00:01.999 am UTC', 'ok', 'nok');
select if(date_add(datetimetz'2008-12-31 22:59:59.999 +00:00', interval '1:00:00.001' hour_millisecond)=datetimeltz'2009-01-01 00:00:00 UTC', 'ok', 'nok');
select if(date_add('2008-12-31 22:59:59.999 UTC', interval '1:00:00.002' hour_millisecond)=datetimetz'2009-01-01 12:00:00.001 AM UTC', 'ok', 'nok');

--test: adddate
--BUG: CUBRIDSUS-17297
select if(adddate(datetimetz'2008-10-18 22:59:00.999', 1)=datetimetz'2008-10-19 23:59:00.999', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12.999 America/Argentina/Cordoba', 1)=datetimetz'2009-3-15 23:11:12.999', 'ok', 'nok');


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
