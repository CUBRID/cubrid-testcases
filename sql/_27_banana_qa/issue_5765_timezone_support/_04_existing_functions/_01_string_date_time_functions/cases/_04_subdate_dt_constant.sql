--test subdate/date_sub functions with DATETIME(L)TZ constant values as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

--test: normal values
select if(subdate(datetimeltz'2014-03-01 12:00:00.999 AM -8:00', interval 1000 millisecond)=datetimetz'2014-02-28 23:59:59.999 -8:00', 'ok', 'nok'); 
select if(subdate(datetimetz'2014-03-01 12:00:00.999 AM Asia/Shanghai', interval 1 second)=datetimetz'2014-02-28 23:59:59.999 +8:00', 'ok', 'nok'); 
select if(subdate(datetimetz'2014-03-01 12:00:00.999 AM +9:00', interval 10 minute)=datetimeltz'2014-02-28 23:50:00.999', 'ok', 'nok'); 
select if(subdate(datetimeltz'2014-02-28 20:00:00.999', interval 5 hour)=datetimetz'2014-03-01 12:00:00.999 AM UTC', 'ok', 'nok'); 
select if(subdate('2014-03-01 12:00:00.999 AM -5:00', interval 1 day)=datetimetz'2014-02-28 12:00:00.999 AM American/New_York', 'ok', 'nok'); 
select if(subdate(datetimetz'2014-03-14 11:59:59.999 PM Asia/Pyongyang', interval 2 week)=datetimetz'2014-02-28 23:59:59.999', 'ok', 'nok'); 
select if(subdate(datetimeltz'2014-12-28 23:59:59.999', interval 10 month)=datetimetz'2014-2-28 22:59:59.999 Asia/Chongqing', 'ok', 'nok'); 
select if(subdate(datetimetz'2015-02-28 15:59:59.999 -8:00', interval 12 quarter)=datetimetz'2012-02-29 23:59:59.999 +0:00', 'ok', 'nok'); 
select if(subdate(datetimetz'2021-02-27 22:00:00.999 -10:00', interval 9 year)=datetimetz'2014-02-29 12:00:00.999 AM -8:00', 'ok', 'nok'); 

--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00
select if(date_sub('2008-10-20 13:58:59.999', interval '-1:1' minute_second)=datetimetz'2008-10-20 16:00:00.999 UTC', 'ok', 'nok');
select if(date_sub('2008-10-20 13:00:00.999', interval '1:1' minute_second)=datetimeltz'2008-10-20 16:58:59.999 UTC', 'ok', 'nok');
select if(date_sub('2008-10-18 1:00:00.999 am', interval '1:1' hour_minute)=datetimetz'2008-10-17 22:59:00.999 -3:00', 'ok', 'nok');
select if(date_sub('2008-10-18 4:00:00.999 AM America/Argentina/Tucuman', interval '1 5:30:30.999' day_second)='2008-10-16 21:30:00.999', 'ok', 'nok');
select if(date_sub(datetimetz'2008-10-18 22:30:00.999', interval '2-1' year_month)='2006-9-18 21:30:00.999');
--[error]??
select subdate('2009-3-14 21:59:59.999', interval '-2:00:01.999' hour_second);
select subdate('2009-3-15 12:30:01.999 AM', interval '1:00:01.999' hour_second);

select if(subdate('2009-3-15 12:30:01.999 AM', interval '1:00:01.999' hour_second)='2009-3-14 11:30:00.999 PM', 'ok', 'nok');
select if(subdate('2009-3-15 12:30:01.999 AM', interval '2:00:01.999' hour_second)='2009-3-14 11:30:00.999 PM', 'ok', 'nok');
select if(subdate('2009-3-15 12:30:01.999 AM', interval '3:00:01.999' hour_second)='2009-3-14 10:30:00.999 PM', 'ok', 'nok');
--??
select if(subdate('2009-3-14 23:11:12.999', interval '1' hour)=datetimetz'2009-3-14 23:11:12.999', 'ok', 'nok');
select if(subdate('2009-3-14 23:11:12.999  America/Argentina/Cordoba', interval '1' hour)=datetimetz'2009-3-14 23:11:12.999');
select if(subdate('2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba'), 'ok', 'nok');
select if(subdate('2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -02'), 'ok', 'nok');
select if(subdate('2009-3-15 12:11:12.999 AM', interval '1' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(subdate('2009-3-15 12:11:12.999 AM', interval '2' hour)='2009-3-14 23:11:12.999 America/Argentina/Cordoba -02', 'ok', 'nok');
--[er]
select if(subdate('2009-3-14 23:11:12.999 America/Argentina/Cordoba KST', interval '1' hour)='2009-3-15 12:11:12.999 AM', 'ok', 'nok');

--test: leap seconds
select if(date_sub('2008-12-31 20:59:59.999', interval '-1' second)=datetimetz'2008-12-31 20:59:59.999', 'ok', 'nok');
select if(date_sub('2008-12-31 20:59:59.999', interval '1' second)=datetimetz'2008-12-31 20:59:59.999', 'ok', 'nok');
select if(date_sub(datetimeltz'2008-12-31 20:59:59.999 America/Argentina/Cordoba', interval '-2' second)='2009-01-01 12:00:00.999 am UTC', 'ok', 'nok');
select if(date_sub(datetimetz'2008-12-31 21:00:00.999 America/Argentina/Cordoba', interval '2' second)='2008-12-31 20:59:59.999 am', 'ok', 'nok');
select if(date_sub(datetimeltz'2009-01-01 12:00:00.999 am UTC', interval '1' second)='2008-12-31 20:59:59.999 America/Argentina/Cordoba', 'ok', 'nok');
select if(date_sub(datetimetz'2009-01-01 12:00:00.999 am UTC', interval '2' second)='2008-12-31 20:59:59.999 America/Argentina/Cordoba', 'ok', 'nok');
select if(date_sub(datetimetz'2009-01-01 12:00:00.999 AM UTC', interval '1:00:01.999' hour_second)=datetimetz'2008-12-31 22:59:59.999 UTC', 'ok', 'nok');
select if(date_sub(datetimeltz'2009-01-01 12:00:00.999 AM UTC', interval '1:00:02.999' hour_second)=datetimetz'2008-12-31 22:59:59.999 UTC', 'ok', 'nok');

--test: subdate
select if(subdate(datetimetz'2008-10-18 23:59:00.999', 1)='2008-10-17 23:59:00.999', 'ok', 'nok');
select if(subdate('2009-3-15 22:11:12.999 America/Argentina/Cordoba', 1)=datetimetz'2009-3-14 23:11:12.999', 'ok', 'nok');


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
