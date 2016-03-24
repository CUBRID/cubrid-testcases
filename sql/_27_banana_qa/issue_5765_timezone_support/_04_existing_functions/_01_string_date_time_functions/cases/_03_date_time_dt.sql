--test date/time functions with DATETIME(L)TZ columns as arguments
set system parameters 'tz_leap_second_support=yes';


drop table if exists tz_test;
create table tz_test(ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone 'Australia/Sydney';
-- 10:00 DST
insert into tz_test values(datetimetz'2009-01-01 10:59:59.999', datetimetz'2009-01-01 10:59:59.999', datetimetz'2009-01-01 10:59:59.999');

--test: addtime
select addtime(ts, time'0:0:1') adt_ts, addtime(dtltz, time'0:0:1') adt_dtltz, addtime(dttz, time'0:0:1') as adt_dttz from tz_test order by 1;

--test: add_months
select add_months(ts, 10), add_months(dtltz, 10), add_months(dttz, 10) from tz_test order by 1;

--test: date
set timezone 'Australia/Sydney';
-- 10:00
select date(ts), date(dtltz), date(dttz) from tz_test order by 1;

--test: datediff
select datediff(ts, '2008-12-31 15:00:00.999') diff_ts, datediff(dtltz, '2008-12-31 15:00:00.999') diff_dtltz, datediff(dttz, '2008-12-31 15:00:00.999') diff_dttz from tz_test order by 1;

--test: day/dayofmonth
select day(ts), dayofmonth(dtltz), day(dttz) from tz_test order by 1;

--test: dayofweek
select dayofweek(ts), dayofweek(dtltz), dayofweek(dttz) from tz_test order by 1;

--test: dayofyear
set timezone 'Africa/Casablanca';
-- 0:00
select dayofyear(ts), dayofyear(dtltz), dayofyear(dttz) from tz_test order by 1;

--test: extract
set timezone '+10:00';
select extract(day from ts) ex_ts, extract(day from dtltz) ex_dtltz, extract(day from ts) ex_dttz from tz_test order by 1;

--test: hour
set timezone '-3:00';
select hour(ts), hour(dtltz), hour(dttz) from tz_test order by 1;

--test: last_day
set timezone 'Asia/Seoul';
select last_day(ts), last_day(dtltz), last_day(dttz) from tz_test order by 1;

--test: minute
select minute(ts), minute(dtltz), minute(dttz) from tz_test order by 1;

--test: month
set timezone '-10:00';
select month(ts), month(dtltz), month(dttz) from tz_test order by 1;

--test: months_between
set timezone 'Asia/Shanghai';
select months_between(ts, datetimetz'2010-06-30 2:00:00.999 Asia/Seoul') mdiff_ts, months_between(dtltz, datetimetz'2010-06-30 2:00:00.999 Asia/Seoul') mdiff_dtltz, months_between(dttz, datetimetz'2010-06-30 2:00:00.999 Asia/Seoul') mdiff_dttz from tz_test order by 1;

--test: quarter
select quarter(ts), quarter(dtltz), quarter(dttz) from tz_test order by 1;

--test: round
select round(ts, 'ss'), round(dtltz, 'ss'), round(dttz, 'ss') from tz_test order by 1;
select round(ts, 'mi'), round(dtltz, 'mi'), round(dttz, 'mi') from tz_test order by 1;
select round(ts, 'hh'), round(dtltz, 'hh'), round(dttz, 'hh') from tz_test order by 1;
 
--test: second
select second(ts), second(dtltz), second(dttz) from tz_test order by 1;

--test: time
set timezone 'Europe/Bucharest'; 
-- 2:00
select time(ts), time(dtltz), time(dttz) from tz_test order by 1;
--test: leap seconds
select time(ts+1), time(dtltz+1), time(dttz+1) from tz_test order by 1;

--test: time_to_sec
select time_to_sec(ts), time_to_sec(dtltz), time_to_sec(dttz) from tz_test order by 1;
select time_to_sec(ts+1), time_to_sec(dtltz+1), time_to_sec(dttz+1) from tz_test order by 1;

--test: timediff
select timediff(ts, datetimetz'2008-12-31 22:59:58.999 UTC') tdiff_ts, timediff(dtltz, datetimetz'2008-12-31 22:59:58.999 UTC') tdiff_dtltz, timediff(dttz, datetimetz'2008-12-31 22:59:58.999 UTC') tdiff_dttz from tz_test order by 1;

--test: timestamp
select timestamp(ts), timestamp(dtltz), timestamp(dttz) from tz_test order by 1;
--test: leap seconds
select timestamp(ts+1), timestamp(dtltz+1), timestamp(dttz+1) from tz_test order by 1;

--test: to_days
set timezone '-7:00';
select to_days(ts), to_days(dtltz), to_days(dttz) from tz_test order by 1;

--test: trunc
select trunc(ts, 'ss'), trunc(dtltz, 'ss'), trunc(dttz, 'ss') from tz_test order by 1;
select trunc(ts, 'mi'), trunc(dtltz, 'mi'), trunc(dttz, 'mi') from tz_test order by 1;
select trunc(ts, 'hh'), trunc(dtltz, 'hh'), trunc(dttz, 'hh') from tz_test order by 1;

--test: unix_timestamp
set timezone 'Asia/Seoul';
select unix_timestamp(ts), unix_timestamp(dtltz), unix_timestamp(dttz) from tz_test order by 1;

--test: utc_date
select utc_date(ts), utc_date(dtltz), utc_date(dttz) from tz_test order by 1;

--test: utc_time
select utc_time(ts), utc_time(dtltz), utc_time(dttz) from tz_test order by 1;

--test: week
select week(ts), week(dtltz), week(dttz) from tz_test order by 1;

--test: weekday
select weekday(ts), weekday(dtltz), weekday(dttz) from tz_test order by 1;

--test: year
set timezone 'Australia/Sydney';
select year(ts), year(dtltz), year(dttz) from tz_test order by 1;

drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
