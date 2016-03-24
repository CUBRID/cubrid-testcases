--test date/time functions with TIMESTAMP(L)TZ columns as arguments
set system parameters 'tz_leap_second_support=yes';


drop table if exists tz_test;
create table tz_test(ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone 'Australia/Sydney';
-- 10:00 DST
insert into tz_test values(timestamptz'2009-01-01 10:59:59', timestamptz'2009-01-01 10:59:59', timestamptz'2009-01-01 10:59:59');

--test: addtime
select addtime(ts, time'0:0:1') adt_ts, addtime(tsltz, time'0:0:1') adt_tsltz, addtime(tstz, time'0:0:1') as adt_tstz from tz_test order by 1;

--test: add_months
select add_months(ts, 10), add_months(tsltz, 10), add_months(tstz, 10) from tz_test order by 1;

--test: date
set timezone 'Australia/Sydney';
-- 10:00
select date(ts), date(tsltz), date(tstz) from tz_test order by 1;

--test: datediff
select datediff(ts, '2008-12-31 15:00:00') diff_ts, datediff(tsltz, '2008-12-31 15:00:00') diff_tsltz, datediff(tstz, '2008-12-31 15:00:00') diff_tstz from tz_test order by 1;

--test: day/dayofmonth
select day(ts), dayofmonth(tsltz), day(tstz) from tz_test order by 1;

--test: dayofweek
select dayofweek(ts), dayofweek(tsltz), dayofweek(tstz) from tz_test order by 1;

--test: dayofyear
set timezone 'Africa/Casablanca';
-- 0:00
select dayofyear(ts), dayofyear(tsltz), dayofyear(tstz) from tz_test order by 1;

--test: extract
set timezone '+10:00';
select extract(day from ts) ex_ts, extract(day from tsltz) ex_tsltz, extract(day from ts) ex_tstz from tz_test order by 1;

--test: hour
set timezone '-3:00';
select hour(ts), hour(tsltz), hour(tstz) from tz_test order by 1;

--test: last_day
set timezone 'Asia/Seoul';
select last_day(ts), last_day(tsltz), last_day(tstz) from tz_test order by 1;

--test: minute
select minute(ts), minute(tsltz), minute(tstz) from tz_test order by 1;

--test: month
set timezone '-10:00';
select month(ts), month(tsltz), month(tstz) from tz_test order by 1;

--test: months_between
set timezone 'Asia/Shanghai';
select months_between(ts, timestamptz'2010-06-30 2:00:00 Asia/Seoul') mdiff_ts, months_between(tsltz, timestamptz'2010-06-30 2:00:00 Asia/Seoul') mdiff_tsltz, months_between(tstz, timestamptz'2010-06-30 2:00:00 Asia/Seoul') mdiff_tstz from tz_test order by 1;

--test: quarter
select quarter(ts), quarter(tsltz), quarter(tstz) from tz_test order by 1;

--test: round
select round(ts, 'ss'), round(tsltz, 'ss'), round(tstz, 'ss') from tz_test order by 1;
select round(ts, 'mi'), round(tsltz, 'mi'), round(tstz, 'mi') from tz_test order by 1;
select round(ts, 'hh'), round(tsltz, 'hh'), round(tstz, 'hh') from tz_test order by 1;
 
--test: second
select second(ts), second(tsltz), second(tstz) from tz_test order by 1;

--test: time
set timezone 'Europe/Bucharest'; 
-- 2:00
select time(ts), time(tsltz), time(tstz) from tz_test order by 1;
--test: leap seconds
select time(ts+1), time(tsltz+1), time(tstz+1) from tz_test order by 1;

--test: time_to_sec
select time_to_sec(ts), time_to_sec(tsltz), time_to_sec(tstz) from tz_test order by 1;
select time_to_sec(ts+1), time_to_sec(tsltz+1), time_to_sec(tstz+1) from tz_test order by 1;

--test: timediff
select timediff(ts, timestamptz'2008-12-31 22:59:58 UTC') tdiff_ts, timediff(tsltz, timestamptz'2008-12-31 22:59:58 UTC') tdiff_tsltz, timediff(tstz, timestamptz'2008-12-31 22:59:58 UTC') tdiff_tstz from tz_test order by 1;

--test: timestamp
select timestamp(ts), timestamp(tsltz), timestamp(tstz) from tz_test order by 1;
--test: leap seconds
select timestamp(ts+1), timestamp(tsltz+1), timestamp(tstz+1) from tz_test order by 1;

--test: to_days
set timezone '-7:00';
select to_days(ts), to_days(tsltz), to_days(tstz) from tz_test order by 1;

--test: trunc
select trunc(ts, 'ss'), trunc(tsltz, 'ss'), trunc(tstz, 'ss') from tz_test order by 1;
select trunc(ts, 'mi'), trunc(tsltz, 'mi'), trunc(tstz, 'mi') from tz_test order by 1;
select trunc(ts, 'hh'), trunc(tsltz, 'hh'), trunc(tstz, 'hh') from tz_test order by 1;

--test: unix_timestamp
set timezone 'Asia/Seoul';
select unix_timestamp(ts), unix_timestamp(tsltz), unix_timestamp(tstz) from tz_test order by 1;

--test: utc_date
select utc_date(ts), utc_date(tsltz), utc_date(tstz) from tz_test order by 1;

--test: utc_time
select utc_time(ts), utc_time(tsltz), utc_time(tstz) from tz_test order by 1;

--test: week
select week(ts), week(tsltz), week(tstz) from tz_test order by 1;

--test: weekday
select weekday(ts), weekday(tsltz), weekday(tstz) from tz_test order by 1;

--test: year
set timezone 'Australia/Sydney';
select year(ts), year(tsltz), year(tstz) from tz_test order by 1;

drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
