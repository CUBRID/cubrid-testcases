--test date/time functions with DATETIME(L)TZ constant values as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

--test: addtime
select if(addtime(datetimeltz'2014-02-28 23:59:59.999 -8:00', time'0:0:1')=datetimetz'2014-03-01 12:00:00.999 AM -8:00', 'ok', 'nok'); 
select if(addtime(datetimetz'2014-02-28 21:58:59.999 Asia/Shanghai', '2:1:1')=datetimetz'2014-03-01 12:00:00.999 AM +8:00', 'ok', 'nok'); 

--test: addmonths
select if(add_months(datetimetz'2013-01-11 23:50:00.999 -8:00', 12)='2014-01-11', 'ok', 'nok'); 
select if(add_months(datetimeltz'2014-07-31 20:00:00.999', -5)=date'2014-02-28', 'ok', 'nok'); 
set timezone '+10:00';
select if(add_months(datetimetz'2014-02-28 20:00:00.999 Asia/Dhaka', 3)=datetimetz'2014-05-31', 'ok', 'nok'); 
select if(add_months(datetimeltz'2014-02-28 20:00:00.999 Asia/Dhaka', 3)=datetimetz'2014-06-01', 'ok', 'nok'); 

--test: date
set timezone 'Australia/Sydney';
-- 10:00, DST (11:00)
select if(date(datetimetz'2014-02-28 23:59:59.999')=date'2014-02-28', 'ok', 'nok'); 
select if(date(datetimeltz'2014-02-28 1:59:59.999 +13:00')=date'2014-02-27', 'ok', 'nok'); 
select if(date(datetimeltz'2014-02-28 23:59:59.999 -4:00')=date'2014-03-01', 'ok', 'nok'); 
select if(date(datetimetz'2014-02-28 23:59:59.999 America/New_York')=date'2014-02-28', 'ok', 'nok'); 

--test: datediff
set timezone 'Africa/Windhoek';
-- 1:00
select if(datediff(datetimeltz'1985-07-01 12:01:01.999', datetimetz'1985-07-01 23:44:56.999')=0, 'ok', 'nok');
select if(datediff(datetimeltz'1991-03-01 5:00:00.999 +10:00', '1991-02-20')=8, 'ok', 'nok');
select if(datediff(datetimeltz'2021-12-31 2:00:00.999 Asia/Seoul', datetimetz'2021-12-31 2:00:00.999 -6:00')=-1, 'ok', 'nok');

--test: day/dayofmonth
set timezone '+10:00';
select if(day(datetimeltz'2033-01-01 3:00:00.999')=1, 'ok', 'nok');
select if(day(datetimetz'2033-01-01 1:00:00.999 +13:00')=1, 'ok', 'nok');
select if(day(datetimeltz'2033-01-01 1:00:00.999 +13:00')=31, 'ok', 'nok');
select if(dayofmonth(datetimetz'2033-01-01 3:00:00.999 Asia/Seoul')=1, 'ok', 'nok');

--test: dayofweek
set timezone '-5:00';
select if(dayofweek(datetimetz'2023-01-01 3:00:00.999')=1, 'ok', 'nok');
select if(dayofweek(datetimeltz'2023-01-01 3:00:00.999 +10:00')=7, 'ok', 'nok');
select if(dayofweek(datetimetz'2023-01-01 3:00:00.999 Asia/Seoul')=1, 'ok', 'nok');

--test: dayofyear
set timezone 'Africa/Casablanca';
-- 0:00
select if(dayofyear(datetimeltz'1988-10-21 12:00:00.999 am')=295, 'ok', 'nok');
select if(dayofyear(datetimetz'1988-10-21 12:00:00.999 am +14:00')=295, 'ok', 'nok');
select if(dayofyear(datetimetz'1988-10-21 12:00:00.999 am Australia/Lindeman')=295, 'ok', 'nok');

--test: extract
set timezone '+10:00';
select if(extract(day from datetimetz'1999-10-1 1:00:00.999')=1, 'ok', 'nok');
select if(extract(day from datetimeltz'1999-10-10 23:00:00.999 -2:00')=11, 'ok', 'nok');
select if(extract(day from datetimetz'1999-10-1 1:00:00.999 Asia/Karachi')=1, 'ok', 'nok');
-- 5:00
--test: DST
set timezone 'Europe/Berlin';
-- 1:00
select if(extract(hour from datetimetz'1999-5-10 13:00:00.999')=11, 'ok', 'nok');
select if(extract(hour from datetimeltz'1999-5-10 09:00:00.999 UTC')=11, 'ok', 'nok');
--test: leap seconds
select if(extract(second from datetimeltz'1981-07-01 1:59:59.999'+1)=0, 'ok', 'nok');

--test: hour
set timezone '-3:00';
select if(hour(datetimeltz'1999-5-10 13:00:00.999 -6:00')=16, 'ok', 'nok');
set timezone '-5:00';
select if(hour(datetimetz'1999-5-10 13:00:00.999')=13, 'ok', 'nok');
select if(hour(datetimetz'1999-5-10 13:00:00.999 +5:00')=13, 'ok', 'nok');
--test: DST
select if(hour(datetimetz'1999-5-10 13:00:00.999 Europe/Berlin')=13, 'ok', 'nok');
select if(hour(datetimeltz'1999-5-10 13:00:00.999 Europe/Berlin')=6, 'ok', 'nok');

--test: last_day
select if(last_day(datetimetz'2005-09-30 23:30:56.999')='2005-09-30', 'ok', 'nok');
select if(last_day(datetimetz'2005-09-30 23:30:56.999 -5:00')='2005-09-30', 'ok', 'nok');
select if(last_day(datetimeltz'2005-09-30 23:30:56.999 America/Recife')='2005-09-30', 'ok', 'nok');
-- -3:00
select if(last_day(datetimeltz'2005-09-30 23:30:56.999 -10:00')='2005-10-31', 'ok', 'nok');

--test: minute
select if(minute(datetimeltz'2005-09-30 23:30:56.999 -5:00')=30, 'ok', 'nok');
--test: leap second
select if(minute(datetimetz'1981-07-01 1:59:59.999 Europe/Berlin'+1)=0, 'ok', 'nok');

--test: month
set timezone '-10:00';
select if(month(datetimetz'2005-09-30 23:30:56.999')=9, 'ok', 'nok');
select if(month(datetimeltz'2005-09-30 23:30:56.999 -12:00')=10, 'ok', 'nok');
select if(month(datetimetz'2005-09-30 23:30:56.999 America/Recife')=9, 'ok', 'nok');
-- -3:00

--test: months_between
set timezone 'Asia/Shanghai';
select if(months_between(datetimetz'2008-12-31 23:59:59.999 -6:00', datetimetz'2010-06-30 2:00:00.999 Asia/Seoul')=-18, 'ok', 'nok');

--test: quarter
select if(quarter(datetimeltz'2005-09-30 23:30:56.999')=3, 'ok', 'nok');
select if(quarter(datetimetz'2005-09-30 23:30:56.999 -5:00')=3, 'ok', 'nok');
select if(quarter(datetimeltz'2005-09-30 23:30:56.999 America/Recife')=4, 'ok', 'nok');
-- -3:00

--test: round
select if(round(datetimetz'2005-09-30 23:30:56.999 -5:00', 'hh')=date'2005-10-01', 'ok', 'nok');
select if(round(datetimeltz'2005-09-30 23:30:56.999 -5:00', 'mi')=date'2005-10-01', 'ok', 'nok');
select if(round(datetimetz'2005-09-30 23:30:56.999 -5:00', 'ss')=date'2005-09-30', 'ok', 'nok');
select if(round(datetimetz'2005-09-14 23:30:56.999 America/Recife', 'dd')=date'2005-09-15', 'ok', 'nok');
-- -3:00
 
--test: second
select if(second(datetimetz'2005-09-30 23:30:56.999 -5:00')=56, 'ok', 'nok');
select if(second(datetimeltz'2005-09-30 23:30:56.999 America/Recife')=56, 'ok', 'nok');
-- -3:00

--test: time, DST
set timezone 'Europe/Bucharest'; 
-- 2:00
select if(time(datetimeltz'1997-04-01 3:00:01.999')=time'3:00:01 AM', 'ok', 'nok');
select if(time(datetimetz'1997-04-01 3:00:01.999 +3:00')=time'3:00:01 AM', 'ok', 'nok');
select if(time(datetimeltz'1997-04-01 3:00:01.999 UTC')=time'6:00:01 AM', 'ok', 'nok');
-- 2:00
--test: leap seconds
select if(time(datetimetz'1990-12-31 23:59:59.999 UTC'+1)=time'00:00:00', 'ok', 'nok');

--test: time_to_sec
set timezone 'Europe/Bucharest'; 
-- 2:00
select if(time_to_sec(datetimetz'1997-04-01 3:00:01.999')=10801, 'ok', 'nok');
select if(time_to_sec(datetimeltz'1997-04-01 3:00:01.999 +2:00')=14401, 'ok', 'nok');
select if(time_to_sec(datetimetz'1997-04-01 3:00:01.999 Europe/Chisinau')=10801, 'ok', 'nok');
-- 2:00
--test: leap seconds
select if(time_to_sec(datetimeltz'1990-12-31 23:59:59.999 UTC'+1)=7200, 'ok', 'nok');
select if(time_to_sec(datetimetz'1990-12-31 23:59:59.999 UTC'+1)=0, 'ok', 'nok');

--test: timediff
select if(timediff(datetimetz'1997-04-01 3:00:01.999', datetimetz'1997-04-01 2:00:01.999')=time'1:00:00', 'ok', 'nok');
select if(timediff(datetimetz'1997-04-01 3:00:01.999 +3:00', datetimetz'1997-04-01 2:00:01.999 Europe/Bucharest')=time'1:00:00', 'ok', 'nok');
select if(timediff(datetimetz'1991-01-01 12:00:00.999 AM UTC', datetimetz'1990-12-31 23:59:59.999 UTC')=time'12:00:01 AM', 'ok', 'nok');
select if(timediff(datetimeltz'1991-01-01 12:00:00.999 AM UTC', datetimetz'1990-12-31 23:59:59.999 UTC')=time'2:00:01 AM', 'ok', 'nok');

--test: datetime
set timezone 'Europe/Bucharest'; 
-- 2:00
select timestamp(datetimeltz'1997-04-01 3:00:01.999');
select timestamp(datetimetz'1997-04-01 3:00:01.999 +3:00');
select timestamp(datetimetz'1997-04-01 2:00:01.999 Europe/Bucharest');
select timestamp(datetimetz'1990-12-31 23:59:59.999 UTC'+1);

--test: to_days
set timezone '-7:00';
select if(to_days(datetimeltz'2005-09-30 23:30:56.999 -10:00')=732585, 'ok', 'nok');
select if(to_days(datetimetz'2005-09-30 23:30:56.999 -2:00')=732584, 'ok', 'nok');
select if(to_days(datetimetz'2005-09-30 23:30:56.999 America/Recife')=732584, 'ok', 'nok');

--test: trunc
select if(trunc(datetimetz'2005-09-30 23:30:56.999', 'hh')=date'2005-09-30', 'ok', 'nok');
select if(trunc(datetimeltz'2005-09-30 23:30:56.999 -10:00', 'hh')=date'2005-10-1', 'ok', 'nok');
select if(trunc(datetimetz'2005-09-30 23:30:56.999 -5:00', 'mi')=date'2005-09-30', 'ok', 'nok');
select if(trunc(datetimeltz'2005-09-30 23:30:56.999 -5:00', 'ss')=date'2005-09-30', 'ok', 'nok');
select if(trunc(datetimetz'2005-09-14 23:30:56.999 America/Recife', 'mon')=date'2005-09-01', 'ok', 'nok');
-- -3:00

--test: utc_datetime
set timezone 'Asia/Seoul';
select if(utc_datetime(datetimeltz'1970-01-01 9:00:00.999')=0, 'ok', 'nok');
select if(utc_datetime(datetimetz'1970-01-01 00:00:00.999 UTC')=0, 'ok', 'nok');
select if(utc_datetime(datetimeltz'1970-01-01 12:00:01.999 AM 0:00')=1, 'ok', 'nok');
select if(utc_datetime(datetimetz'1970-01-01 12:00:00.999 AM 2:00')=7200, 'ok', 'nok');
set timezone 'America/Winnipeg';
-- -6:00, DST
select if(utc_datetime(datetimetz'2000-06-13 23:45:36.999')=960857136, 'ok', 'nok');
select if(utc_datetime(datetimeltz'2000-06-13 23:45:36.999 -5:00')=960857136, 'ok', 'nok');
select if(utc_datetime(datetimetz'2000-06-13 23:45:36.999 America/Winnipeg')=960857136, 'ok', 'nok');

--test: utc_date
select utc_date(datetimetz'2000-06-13 23:45:36.999');
select utc_date(datetimetz'2000-06-13 23:45:36.999 -1:00');
select utc_date(datetimeltz'2000-06-13 19:45:36.999 America/Winnipeg');

--test: utc_time
select utc_time(datetimeltz'2000-06-13 23:45:36.999');
select utc_time(datetimetz'2000-06-13 23:45:36.999 -5:00');
select utc_time(datetimetz'2000-06-13 23:45:36.999 America/Winnipeg');

--test: week
select if(week(datetimetz'2000-06-17 23:45:36.999')=24, 'ok', 'nok');
select if(week(datetimeltz'2000-06-17 23:45:36.999 -10:00')=25, 'ok', 'nok');
select if(week(datetimetz'2000-06-17 19:45:36.999 America/Winnipeg')=24, 'ok', 'nok');

--test: weekday
select if(weekday(datetimetz'2000-06-17 23:45:36.999')=5, 'ok', 'nok');
select if(weekday(datetimeltz'2000-06-17 23:45:36.999 -10:00')=6, 'ok', 'nok');
select if(weekday(datetimeltz'2000-06-17 19:45:36.999 America/Winnipeg')=5, 'ok', 'nok');

--test: year
select if(year(datetimeltz'2000-12-31 23:45:36.999')=2000, 'ok', 'nok');
select if(year(datetimetz'2000-12-31 23:45:36.999 -1:00')=2000, 'ok', 'nok');
select if(year(datetimeltz'2000-12-31 23:45:36.999 America/Adak')=2001, 'ok', 'nok');


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
