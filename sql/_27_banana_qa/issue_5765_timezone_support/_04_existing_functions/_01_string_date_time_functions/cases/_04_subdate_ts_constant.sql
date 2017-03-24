--test subdate/date_sub functions with TIMESTAMP(L)TZ constant values as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

--test: normal values
select if(subdate(timestampltz'2014-03-01 12:00:00 AM -8:00', interval 1000 millisecond)=timestamptz'2014-02-28 23:59:59 -8:00', 'ok', 'nok'); 
select if(subdate(timestamptz'2014-03-01 12:00:00 AM Asia/Shanghai', interval 1 second)=timestamptz'2014-02-28 23:59:59 +8:00', 'ok', 'nok'); 
select if(subdate(timestamptz'2014-03-01 12:00:00 AM +9:00', interval 10 minute)=timestampltz'2014-02-28 23:50:00', 'ok', 'nok'); 
select if(subdate(timestampltz'2014-02-28 20:00:00', interval 5 hour)=timestamptz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok'); 
select if(subdate('2014-03-01 12:00:00 AM -5:00', interval 1 day)=timestamptz'2014-02-28 12:00:00 AM America/New_York', 'ok', 'nok'); 
select if(subdate(timestamptz'2014-03-14 11:59:59 PM Asia/Pyongyang', interval 2 week)=timestamptz'2014-02-28 23:59:59', 'ok', 'nok'); 
select if(subdate(timestampltz'2014-12-28 23:59:59', interval 10 month)=timestamptz'2014-2-28 22:59:59 Asia/Chongqing', 'ok', 'nok'); 
select if(subdate(timestamptz'2015-02-28 15:59:59 -8:00', interval 12 quarter)=timestamptz'2012-02-29 23:59:59 +0:00', 'ok', 'nok'); 
select if(subdate(timestamptz'2021-02-27 22:00:00 -10:00', interval 9 year)=timestamptz'2012-02-28 12:00:00 AM -8:00', 'ok', 'nok'); 

--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00
select if(date_sub('2008-10-20 13:58:59', interval '-1:1' minute_second)=timestamptz'2008-10-20 16:00:00 UTC', 'ok', 'nok');
select if(date_sub('2008-10-20 13:00:00', interval '1:1' minute_second)=timestampltz'2008-10-20 16:58:59 UTC', 'ok', 'nok');
select if(date_sub('2008-10-18 1:00:00 am', interval '1:1' hour_minute)=timestamptz'2008-10-17 22:59:00 -3:00', 'ok', 'nok');
select if(date_sub('2008-10-18 4:00:00 AM America/Argentina/Tucuman', interval '1 5:30:30' day_second)='2008-10-16 21:30:00', 'ok', 'nok');
select if(date_sub(timestamptz'2008-10-18 22:30:00', interval '2-1' year_month)='2006-9-18 21:30:00', 'ok', 'nok');
--[error]??
select subdate('2009-3-14 21:59:59', interval '-2:00:01' hour_second);
select subdate('2009-3-15 12:30:01 AM', interval '1:00:01' hour_second);

select if(subdate('2009-3-15 12:30:01 AM', interval '1:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok');
select if(subdate('2009-3-15 12:30:01 AM', interval '2:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok');
select if(subdate('2009-3-15 12:30:01 AM', interval '3:00:01' hour_second)='2009-3-14 10:30:00 PM', 'ok', 'nok');
--??
select if(subdate('2009-3-14 23:11:12', interval '1' hour)=timestamptz'2009-3-14 23:11:12', 'ok', 'nok');
select if(subdate('2009-3-14 23:11:12  America/Argentina/Cordoba', interval '1' hour)=timestamptz'2009-3-14 23:11:12', 'ok', 'nok');
select if(subdate('2009-3-14 23:11:12 America/Argentina/Cordoba -03', interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba', 'ok', 'nok');
select if(subdate('2009-3-14 23:11:12 America/Argentina/Cordoba -03', interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02', 'ok', 'nok');
select if(subdate('2009-3-15 12:11:12 AM', interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(subdate('2009-3-15 12:11:12 AM', interval '2' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02', 'ok', 'nok');
--[er]
select if(subdate('2009-3-14 23:11:12 America/Argentina/Cordoba KST', interval '1' hour)='2009-3-15 12:11:12 AM', 'ok', 'nok');

--test: leap seconds
select if(date_sub('2008-12-31 20:59:59', interval '-1' second)=timestamptz'2008-12-31 20:59:59', 'ok', 'nok');
select if(date_sub('2008-12-31 20:59:59', interval '1' second)=timestamptz'2008-12-31 20:59:59', 'ok', 'nok');
select if(date_sub(timestampltz'2008-12-31 20:59:59 America/Argentina/Cordoba', interval '-2' second)='2009-01-01 12:00:00 am UTC', 'ok', 'nok');
select if(date_sub(timestamptz'2008-12-31 21:00:00 America/Argentina/Cordoba', interval '2' second)='2008-12-31 20:59:59', 'ok', 'nok');
select if(date_sub(timestampltz'2009-01-01 12:00:00 am UTC', interval '1' second)='2008-12-31 20:59:59 America/Argentina/Cordoba', 'ok', 'nok');
select if(date_sub(timestamptz'2009-01-01 12:00:00 am UTC', interval '2' second)='2008-12-31 20:59:59 America/Argentina/Cordoba', 'ok', 'nok');
select if(date_sub(timestamptz'2009-01-01 12:00:00 AM UTC', interval '1:00:01' hour_second)=timestamptz'2008-12-31 22:59:59 UTC', 'ok', 'nok');
select if(date_sub(timestampltz'2009-01-01 12:00:00 AM UTC', interval '1:00:02' hour_second)=timestamptz'2008-12-31 22:59:59 UTC', 'ok', 'nok');

--test: subdate
select if(subdate(timestamptz'2008-10-18 23:59:00', 1)='2008-10-17 23:59:00', 'ok', 'nok');
select if(subdate('2009-3-15 22:11:12 America/Argentina/Cordoba', 1)=timestamptz'2009-3-14 23:11:12', 'ok', 'nok');


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
