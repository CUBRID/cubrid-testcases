--test adddate/date_add functions with TIMESTAMP(L)TZ constant values as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

--test: normal values
--BUG: CUBRIDSUS-15254, resolved
select if(adddate(timestamptz'2014-02-28 23:59:59 -8:00', interval 1000 millisecond)=timestampltz'2014-03-01 12:00:00 AM -8:00', 'ok', 'nok'); 
select if(adddate(timestampltz'2014-02-28 23:59:59 Asia/Shanghai', interval 1 second)=timestampltz'2014-03-01 12:00:00 AM +8:00', 'ok', 'nok'); 
select if(adddate(timestamptz'2014-02-28 23:50:00', interval 10 minute)=timestampltz'2014-03-01 12:00:00 AM +9:00', 'ok', 'nok'); 
select if(adddate(timestampltz'2014-02-28 20:00:00 -9:00', interval -5 hour)=timestampltz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok'); 
select if(adddate(timestamptz'2014-02-28 12:00:00 AM America/New_York', interval 1 day)=timestampltz'2014-03-01 12:00:00 AM -5:00', 'ok', 'nok'); 
select if(adddate(timestamptz'2014-02-28 23:59:59', interval 2 week)=timestampltz'2014-03-14 11:59:59 PM Asia/Pyongyang', 'ok', 'nok'); 
select if(adddate(timestampltz'2014-02-28 23:59:59', interval 10 month)=timestampltz'2014-12-28 22:59:59 Asia/Chongqing', 'ok', 'nok'); 
select if(adddate(timestamptz'2012-02-29 23:59:59 +0:00', interval 12 quarter)=timestampltz'2015-02-28 15:59:59 -8:00', 'ok', 'nok'); 
select if(adddate(timestamptz'2012-02-29 12:00:00 AM -8:00', interval 9 year)=timestampltz'2021-02-27 22:00:00 -10:00', 'ok', 'nok'); 

--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00
--BUG: CUBRIDSUS-15166, resolved
select if(date_add('2008-10-20 13:58:59', interval '1:1' minute_second)=timestamptz'2008-10-20 16:00:00 UTC', 'ok', 'nok');
--BUG: CUBRIDSUS-16479, resolved
select if(date_add('2008-10-18 22:59:00 -3:00', interval '1:1' hour_minute)=timestamptz'2008-10-19 1:00:00 am', 'ok', 'nok');
--BUG: CUBRIDSUS-16750, resolved
select if(date_add('2008-10-17 21:30:00 America/Argentina/Tucuman', interval '1 5:30:00' day_second)=datetime'2008-10-19 4:00:00 AM', 'ok', 'nok');
--BUG: CUBRIDSUS-16426, resolved
select if(date_add('2008-10-18 23:30:00 America/Argentina/Tucuman', interval '30' second)=timestamp'2008-10-18 23:30:30', 'ok', 'nok');
--BUG: CUBRIDSUS-15032, resolved
select if(date_add(timestampltz'2006-9-19 21:30:00', interval '2-1' year_month)='2008-10-19 22:30:00', 'ok', 'nok');
select if(date_add(timestamptz'2006-9-19 21:30:00', interval '2-1' year_month)='2008-10-19 22:30:00', 'ok', 'nok');
--[error]??
--BUG: CUBRIDSUS-15181, resolved
select adddate('2009-3-14 21:59:59', interval '2:00:01' hour_second);
--BUG: CUBRIDSUS-17263, resolved
select if(adddate(timestampltz'2009-3-14 21:59:59', interval '2:00:01' hour_second)='2009-3-14 11:00:00 PM America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate(timestampltz'2009-3-14 23:11:12', interval '1' hour)=timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate(timestamptz'2009-3-14 23:11:12', interval '1' hour)=timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12 America/Argentina/Cordoba', interval '1' hour)=timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok');
--BUG: CUBRIDSUS-17332
select if(adddate('2009-3-14 23:11:12 America/Argentina/Cordoba -02', interval '1' hour)=timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12 America/Argentina/Cordoba -03', interval '1' hour)=timestamptz'2009-3-15 12:11:12 AM', 'ok', 'nok');
--[er]
select if(adddate('2009-3-14 23:11:12 America/Argentina/Cordoba KST', interval '1' hour)=timestamptz'2009-3-15 12:11:12 AM', 'ok', 'nok');

--test: leap seconds
select if(date_add('2008-12-31 21:59:59', interval '1' second)=timestamptz'2008-12-31 21:59:59', 'ok', 'nok');
--BUG: CUBRIDSUS-16595
select if(date_add(timestamptz'2008-12-31 21:59:59 America/Argentina/Cordoba', interval '2' second)=timestamptz'2009-01-01 12:00:00 am UTC', 'ok', 'nok');
select if(date_add(timestamptz'2008-12-31 22:59:59 +00:00', interval '1:00:01' hour_second)=timestampltz'2008-12-31 23:59:59 UTC', 'ok', 'nok');
select if(date_add('2008-12-31 22:59:59 UTC', interval '1:00:02' hour_second)=timestamptz'2009-01-01 12:00:00 AM UTC', 'ok', 'nok');

--test: adddate
select if(adddate(timestamptz'2008-10-18 22:59:00', 1)='2008-10-19 23:59:00', 'ok', 'nok');
select if(adddate('2009-3-14 23:11:12 America/Argentina/Cordoba', 1)=timestamptz'2009-3-15 22:11:12', 'ok', 'nok');


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
