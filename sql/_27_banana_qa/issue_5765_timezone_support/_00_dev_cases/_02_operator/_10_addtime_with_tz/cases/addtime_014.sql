--TEST: pass out-of-range data of date/timestamptz/datetimetz type to the 2nd parameter



--TEST: 1. [error] out-of-range argument of date type
select addtime('14:59:59', date'13/11/1989');

select addtime('14:59:59', date'05/33/1901');

select addtime('14:59:59', date'2/20/10000');

select addtime('14:59:59', date'0-1-1');

select addtime('14:59:59', date'1999-04-31');

select addtime('14:59:59', date'03-02-31');

select addtime('14:59:59', date'0000-00-00');

--TEST: 2. [error] out-of-range argument of timestamptz type
select addtime('14:59:59', timestamptz'23:00:00 13/01');

select addtime('14:59:59', timestamptz'04:14:07 1/19/2038');

select addtime('14:59:59', timestamptz'03:15:07 1/19/2038');

select addtime('14:59:59', timestamptz'03:14:08 1/19/2038');

select addtime('14:59:59', timestamptz'03:14:07 2/19/2038');

select addtime('14:59:59', timestamptz'03:14:07 1/20/2038');

select addtime('14:59:59', timestamptz'03:14:07 1/19/2039');

--TEST: ??
select addtime('14:59:59', timestamptz'03:14:07 PM 1/19/2038');

select addtime('14:59:59', timestamptz'0:0:0 PM 1969-01-01');

select addtime('14:59:59', timestamptz'11:03:22 PM 1864-01-23');

select addtime('14:59:59', timestamptz'2300-12-12 22:02:33');

select addtime('14:59:59', timestamptz'2020-23-11 03:14:66 pm');

select addtime('14:59:59', timestamptz'1970-10-101 0:0');

select addtime('14:59:59', timestamptz'1999/12/11 3:14:7 am');

select addtime('14:59:59', timestamptz'2010-4-31 3:14:7 am');



--TEST: 3. [error] out-of-range argument of datetimetz type
select addtime('14:59:59', datetimetz'2010-10 10:10:100.00 am');

select addtime('14:59:59', datetimetz'24:59:59.999 12/31/9999');

select addtime('14:59:59', datetimetz'23:60:59.999 12/31/9999');

select addtime('14:59:59', datetimetz'23:59:60.999 12/31/9999');

select addtime('14:59:59', datetimetz'23:59:59.1000 12/31/9999');

select addtime('14:59:59', datetimetz'23:59:59.999 13/31/9999');

select addtime('14:59:59', datetimetz'23:59:59.999 12/32/9999');

select addtime('14:59:59', datetimetz'23:59:59.999 12/31/10000');

select addtime('14:59:59', datetimetz'20:33:61.111 1990-10-19 ');

select addtime('14:59:59', datetimetz'2/31/2022 10:20:30.400');

select addtime('14:59:59', datetimetz'12/31/9999 23:59:59.999');

select addtime('14:59:59', datetimetz'0-12-12 23:59:59.999');




--TEST: 4. [error] out-of-range argument of time type
select addtime(time'9:19:29', time'10:10:100.00 am');

select addtime(time'9:19:29', time'24:59:59.999');

select addtime(time'9:19:29', time'23:60:59.999');

select addtime(time'9:19:29', time'23:59:60.999');

select addtime(time'9:19:29', time'23:60:59');

select addtime(time'9:19:29', time'188:59:59');
