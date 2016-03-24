--TEST: pass out-of-range data of date/timestampltz/datetimeltz type to the 2nd parameter



--TEST: 1. [error] out-of-range argument of date type
select addtime('14:59:59', date'13/11/1989');

select addtime('14:59:59', date'05/33/1901');

select addtime('14:59:59', date'2/20/10000');

select addtime('14:59:59', date'0-1-1');

select addtime('14:59:59', date'1999-04-31');

select addtime('14:59:59', date'03-02-31');

select addtime('14:59:59', date'0000-00-00');

--TEST: 2. [error] out-of-range argument of timestampltz type
select addtime('14:59:59', timestampltz'23:00:00 13/01');

select addtime('14:59:59', timestampltz'04:14:07 1/19/2038');

select addtime('14:59:59', timestampltz'03:15:07 1/19/2038');

select addtime('14:59:59', timestampltz'03:14:08 1/19/2038');

select addtime('14:59:59', timestampltz'03:14:07 2/19/2038');

select addtime('14:59:59', timestampltz'03:14:07 1/20/2038');

select addtime('14:59:59', timestampltz'03:14:07 1/19/2039');

--TEST: ??
select addtime('14:59:59', timestampltz'03:14:07 PM 1/19/2038');

select addtime('14:59:59', timestampltz'0:0:0 PM 1969-01-01');

select addtime('14:59:59', timestampltz'11:03:22 PM 1864-01-23');

select addtime('14:59:59', timestampltz'2300-12-12 22:02:33');

select addtime('14:59:59', timestampltz'2020-23-11 03:14:66 pm');

select addtime('14:59:59', timestampltz'1970-10-101 0:0');

select addtime('14:59:59', timestampltz'1999/12/11 3:14:7 am');

select addtime('14:59:59', timestampltz'2010-4-31 3:14:7 am');



--TEST: 3. [error] out-of-range argument of datetimeltz type
select addtime('14:59:59', datetimeltz'2010-10 10:10:100.00 am');

select addtime('14:59:59', datetimeltz'24:59:59.999 12/31/9999');

select addtime('14:59:59', datetimeltz'23:60:59.999 12/31/9999');

select addtime('14:59:59', datetimeltz'23:59:60.999 12/31/9999');

select addtime('14:59:59', datetimeltz'23:59:59.1000 12/31/9999');

select addtime('14:59:59', datetimeltz'23:59:59.999 13/31/9999');

select addtime('14:59:59', datetimeltz'23:59:59.999 12/32/9999');

select addtime('14:59:59', datetimeltz'23:59:59.999 12/31/10000');

select addtime('14:59:59', datetimeltz'20:33:61.111 1990-10-19 ');

select addtime('14:59:59', datetimeltz'2/31/2022 10:20:30.400');

select addtime('14:59:59', datetimeltz'12/31/9999 23:59:59.999');

select addtime('14:59:59', datetimeltz'0-12-12 23:59:59.999');




--TEST: 4. [error] out-of-range argument of time type
select addtime(time'9:19:29', time'10:10:100.00 am');

select addtime(time'9:19:29', time'24:59:59.999');

select addtime(time'9:19:29', time'23:60:59.999');

select addtime(time'9:19:29', time'23:59:60.999');

select addtime(time'9:19:29', time'23:60:59');

select addtime(time'9:19:29', time'188:59:59');
