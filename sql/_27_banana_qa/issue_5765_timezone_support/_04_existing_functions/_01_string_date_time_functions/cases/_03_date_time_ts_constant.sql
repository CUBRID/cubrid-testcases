--test date/time functions with TIMESTAMP(L)TZ constant values as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

--test: addtime
select if(addtime(timestampltz'2014-02-28 23:59:59 -8:00', time'0:0:1')=timestamptz'2014-03-01 12:00:00 AM -8:00', 'ok', 'nok'); 
--BUG: CUBRIDSUS-15166, resolved
select if(addtime(timestamptz'2014-02-28 21:58:59 Asia/Shanghai', '2:1:1')='12:00:00.000 AM 03/01/2014 Asia/Shanghai', 'ok', 'nok'); 

--test: addmonths
select if(add_months(timestamptz'2013-01-11 23:50:00 -8:00', 12)='2014-01-11', 'ok', 'nok'); 
select if(add_months(timestampltz'2014-07-31 20:00:00', -5)=date'2014-02-28', 'ok', 'nok'); 
set timezone '+10:00';
select if(add_months(timestamptz'2014-02-28 20:00:00 Asia/Dhaka', 3)=timestamptz'2014-05-31', 'ok', 'nok'); 
select if(add_months(timestampltz'2014-02-28 20:00:00 Asia/Dhaka', 3)=timestamptz'2014-06-01', 'ok', 'nok'); 

--test: date
set timezone 'Australia/Sydney';
-- 10:00, DST (11:00)
select if(date(timestamptz'2014-02-28 23:59:59')=date'2014-02-28', 'ok', 'nok'); 
select if(date(timestampltz'2014-02-28 1:59:59 +13:00')=date'2014-02-27', 'ok', 'nok'); 
select if(date(timestampltz'2014-02-28 23:59:59 -4:00')=date'2014-03-01', 'ok', 'nok'); 
select if(date(timestamptz'2014-02-28 23:59:59 America/New_York')=date'2014-02-28', 'ok', 'nok'); 

--test: datediff
set timezone 'Africa/Windhoek';
-- 1:00
select if(datediff(timestampltz'1985-07-01 12:01:01', timestamptz'1985-07-01 23:44:56')=0, 'ok', 'nok');
select if(datediff(timestampltz'1991-03-01 5:00:00 +10:00', '1991-02-20')=8, 'ok', 'nok');
select if(datediff(timestampltz'2021-12-31 2:00:00 Asia/Seoul', timestamptz'2021-12-31 2:00:00 -6:00')=-1, 'ok', 'nok');

--test: day/dayofmonth
set timezone '+10:00';
select if(day(timestampltz'2033-01-01 3:00:00')=1, 'ok', 'nok');
select if(day(timestamptz'2033-01-01 1:00:00 +13:00')=1, 'ok', 'nok');
select if(day(timestampltz'2033-01-01 1:00:00 +13:00')=31, 'ok', 'nok');
select if(dayofmonth(timestamptz'2033-01-01 3:00:00 Asia/Seoul')=1, 'ok', 'nok');

--test: dayofweek
set timezone '-5:00';
select if(dayofweek(timestamptz'2023-01-01 3:00:00')=1, 'ok', 'nok');
select if(dayofweek(timestampltz'2023-01-01 3:00:00 +10:00')=7, 'ok', 'nok');
select if(dayofweek(timestamptz'2023-01-01 3:00:00 Asia/Seoul')=1, 'ok', 'nok');

--test: dayofyear
set timezone 'Africa/Casablanca';
-- 0:00
select if(dayofyear(timestampltz'1988-10-21 12:00:00 am')=295, 'ok', 'nok');
select if(dayofyear(timestamptz'1988-10-21 12:00:00 am +14:00')=295, 'ok', 'nok');
select if(dayofyear(timestamptz'1988-10-21 12:00:00 am Australia/Lindeman')=295, 'ok', 'nok');

--test: extract
set timezone '+10:00';
select if(extract(day from timestamptz'1999-10-1 1:00:00')=1, 'ok', 'nok');
select if(extract(day from timestampltz'1999-10-10 23:00:00 -2:00')=11, 'ok', 'nok');
select if(extract(day from timestamptz'1999-10-1 1:00:00 Asia/Karachi')=1, 'ok', 'nok');
-- 5:00
--test: DST
set timezone 'Europe/Berlin';
-- 1:00
select if(extract(hour from timestamptz'1999-5-10 13:00:00')=13, 'ok', 'nok');
select if(extract(hour from timestampltz'1999-5-10 09:00:00 UTC')=11, 'ok', 'nok');
--test: leap seconds
select if(extract(second from timestampltz'1981-07-01 1:59:59'+1)=59, 'ok', 'nok');

--test: hour
set timezone '-3:00';
select if(hour(timestampltz'1999-5-10 13:00:00 -6:00')=16, 'ok', 'nok');
set timezone '-5:00';
select if(hour(timestamptz'1999-5-10 13:00:00')=13, 'ok', 'nok');
select if(hour(timestamptz'1999-5-10 13:00:00 +5:00')=13, 'ok', 'nok');
--test: DST
select if(hour(timestamptz'1999-5-10 13:00:00 Europe/Berlin')=13, 'ok', 'nok');
select if(hour(timestampltz'1999-5-10 13:00:00 Europe/Berlin')=6, 'ok', 'nok');

--test: last_day
select if(last_day(timestamptz'2005-09-30 23:30:56')='2005-09-30', 'ok', 'nok');
select if(last_day(timestamptz'2005-09-30 23:30:56 -5:00')='2005-09-30', 'ok', 'nok');
select if(last_day(timestampltz'2005-09-30 23:30:56 America/Recife')='2005-09-30', 'ok', 'nok');
-- -3:00
select if(last_day(timestampltz'2005-09-30 23:30:56 -10:00')='2005-10-31', 'ok', 'nok');

--test: minute
select if(minute(timestampltz'2005-09-30 23:30:56 -5:00')=30, 'ok', 'nok');
--test: leap second
select if(minute(timestamptz'1981-07-01 1:59:59 Europe/Berlin'+1)=59, 'ok', 'nok');

--test: month
set timezone '-10:00';
select if(month(timestamptz'2005-09-30 23:30:56')=9, 'ok', 'nok');
select if(month(timestampltz'2005-09-30 23:30:56 -12:00')=10, 'ok', 'nok');
select if(month(timestamptz'2005-09-30 23:30:56 America/Recife')=9, 'ok', 'nok');
-- -3:00

--test: months_between
set timezone 'Asia/Shanghai';
select if(months_between(timestamptz'2008-12-31 23:59:59 -6:00', timestamptz'2010-06-30 2:00:00 Asia/Seoul')=-18, 'ok', 'nok');

--test: quarter
select if(quarter(timestampltz'2005-09-30 23:30:56')=3, 'ok', 'nok');
select if(quarter(timestamptz'2005-09-30 23:30:56 -5:00')=3, 'ok', 'nok');
select if(quarter(timestampltz'2005-09-30 23:30:56 America/Recife')=4, 'ok', 'nok');
-- -3:00

--test: round
select if(round(timestamptz'2005-09-30 23:30:56 -5:00', 'hh')=date'2005-10-01', 'ok', 'nok');
select if(round(timestampltz'2005-09-30 23:30:56 -5:00', 'mi')=date'2005-10-01', 'ok', 'nok');
select if(round(timestamptz'2005-09-30 23:30:56 -5:00', 'ss')=date'2005-09-30', 'ok', 'nok');
select if(round(timestamptz'2005-09-14 23:30:56 America/Recife', 'dd')=date'2005-09-15', 'ok', 'nok');
-- -3:00
 
--test: second
select if(second(timestamptz'2005-09-30 23:30:56 -5:00')=56, 'ok', 'nok');
select if(second(timestampltz'2005-09-30 23:30:56 America/Recife')=56, 'ok', 'nok');
-- -3:00

--test: time, DST
set timezone 'Europe/Bucharest'; 
-- 2:00
select if(time(timestampltz'1997-04-01 3:00:01')=time'3:00:01 AM', 'ok', 'nok');
select if(time(timestamptz'1997-04-01 3:00:01 +3:00')=time'3:00:01 AM', 'ok', 'nok');
select if(time(timestampltz'1997-04-01 3:00:01 UTC')=time'6:00:01 AM', 'ok', 'nok');
-- 2:00
--test: leap seconds
select if(time(timestamptz'1990-12-31 23:59:59 UTC'+1)=time'23:59:59', 'ok', 'nok');

--test: time_to_sec
set timezone 'Europe/Bucharest'; 
-- 2:00
select if(time_to_sec(timestamptz'1997-04-01 3:00:01')=10801, 'ok', 'nok');
select if(time_to_sec(timestampltz'1997-04-01 3:00:01 +2:00')=14401, 'ok', 'nok');
select if(time_to_sec(timestamptz'1997-04-01 3:00:01 Europe/Chisinau')=10801, 'ok', 'nok');
-- 2:00
--test: leap seconds
select if(time_to_sec(timestampltz'1990-12-31 23:59:59 UTC'+1)=7199, 'ok', 'nok');
select if(time_to_sec(timestamptz'1990-12-31 23:59:59 UTC'+1)=86399, 'ok', 'nok');

--test: timediff
select if(timediff(timestamptz'1997-04-01 3:00:01', timestamptz'1997-04-01 2:00:01')=time'1:00:00', 'ok', 'nok');
select if(timediff(timestamptz'1997-04-01 3:00:01 +3:00', timestamptz'1997-04-01 2:00:01 Europe/Bucharest')=time'1:00:00', 'ok', 'nok');
select if(timediff(timestamptz'1991-01-01 12:00:00 AM UTC', timestamptz'1990-12-31 23:59:59 UTC')=time'12:00:01 AM', 'ok', 'nok');
select if(timediff(timestampltz'1991-01-01 12:00:00 AM UTC', timestamptz'1990-12-31 23:59:59 UTC')=time'2:00:01 AM', 'ok', 'nok');

--test: timestamp
set timezone 'Europe/Bucharest'; 
-- 2:00
select timestamp(timestampltz'1997-04-01 3:00:01');
select timestamp(timestamptz'1997-04-01 3:00:01 +3:00');
select timestamp(timestamptz'1997-04-01 2:00:01 Europe/Bucharest');
select timestamp(timestamptz'1990-12-31 23:59:59 UTC'+1);

--test: to_days
set timezone '-7:00';
select if(to_days(timestampltz'2005-09-30 23:30:56 -10:00')=732585, 'ok', 'nok');
select if(to_days(timestamptz'2005-09-30 23:30:56 -2:00')=732584, 'ok', 'nok');
select if(to_days(timestamptz'2005-09-30 23:30:56 America/Recife')=732584, 'ok', 'nok');

--test: trunc
select if(trunc(timestamptz'2005-09-30 23:30:56', 'hh')=date'2005-09-30', 'ok', 'nok');
select if(trunc(timestampltz'2005-09-30 23:30:56 -10:00', 'hh')=date'2005-10-1', 'ok', 'nok');
select if(trunc(timestamptz'2005-09-30 23:30:56 -5:00', 'mi')=date'2005-09-30', 'ok', 'nok');
select if(trunc(timestampltz'2005-09-30 23:30:56 -5:00', 'ss')=date'2005-09-30', 'ok', 'nok');
select if(trunc(timestamptz'2005-09-14 23:30:56 America/Recife', 'mon')=date'2005-09-01', 'ok', 'nok');
-- -3:00

--test: unix_timestamp
set timezone 'Asia/Seoul';
select if(unix_timestamp(timestampltz'1970-01-01 9:00:00')=0, 'ok', 'nok');
select if(unix_timestamp(timestamptz'1970-01-01 00:00:00 UTC')=0, 'ok', 'nok');
select if(unix_timestamp(timestampltz'1970-01-01 12:00:01 AM +0:00')=1, 'ok', 'nok');
select if(unix_timestamp(timestamptz'1970-01-01 12:00:00 AM +2:00')=7200, 'ok', 'nok');
set timezone 'America/Winnipeg';
-- -6:00, DST
--BUG: CUBRIDSUS-16621, planned for banana pie
--960857136 is unix_timestamp of '2000-06-13 08:45:36.0 +08:00'
select if(unix_timestamp(timestamptz'2000-06-12 19:45:36')=960857158, 'ok', 'nok');
select if(unix_timestamp(timestampltz'2000-06-12 19:45:36 -5:00')=960857158, 'ok', 'nok');
select if(unix_timestamp(timestamptz'2000-06-12 19:45:36 America/Winnipeg')=960857158, 'ok', 'nok');

--test: utc_date
select utc_date(timestamptz'2000-06-13 23:45:36');
select utc_date(timestamptz'2000-06-13 23:45:36 -1:00');
select utc_date(timestampltz'2000-06-13 19:45:36 America/Winnipeg');

--test: utc_time
select utc_time(timestampltz'2000-06-13 23:45:36');
select utc_time(timestamptz'2000-06-13 23:45:36 -5:00');
select utc_time(timestamptz'2000-06-13 23:45:36 America/Winnipeg');

--test: week
select if(week(timestamptz'2000-06-17 23:45:36')=24, 'ok', 'nok');
select if(week(timestampltz'2000-06-17 23:45:36 -10:00')=25, 'ok', 'nok');
select if(week(timestamptz'2000-06-17 19:45:36 America/Winnipeg')=24, 'ok', 'nok');

--test: weekday
select if(weekday(timestamptz'2000-06-17 23:45:36')=5, 'ok', 'nok');
select if(weekday(timestampltz'2000-06-17 23:45:36 -10:00')=6, 'ok', 'nok');
select if(weekday(timestampltz'2000-06-17 19:45:36 America/Winnipeg')=5, 'ok', 'nok');

--test: year
select if(year(timestampltz'2000-12-31 23:45:36')=2000, 'ok', 'nok');
select if(year(timestamptz'2000-12-31 23:45:36 -1:00')=2000, 'ok', 'nok');
select if(year(timestampltz'2000-12-31 23:45:36 America/Adak')=2001, 'ok', 'nok');


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
