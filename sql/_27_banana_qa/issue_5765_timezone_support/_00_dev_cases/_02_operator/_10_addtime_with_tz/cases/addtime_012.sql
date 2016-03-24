--TEST: pass out-of-range data of string type to the 1st parameter



--TEST: 1. out-of-range argument: date type
select addtime(date'13/11/1989', time'9:19:29');

select addtime(date'05/33/1901', time'9:19:29');

select addtime(date'2/20/10000', time'9:19:29');

select addtime(date'0-1-1', time'9:19:29');

select addtime(date'1999-04-31', time'9:19:29');

select addtime(date'03-02-31', time'9:19:29');



--TEST: 2. out-of-range argument: timestamptz type
select addtime(timestamptz'23:00:00 13/01', time'9:19:29');

select addtime(timestamptz'04:14:07 1/19/2038', time'9:19:29');

select addtime(timestamptz'03:15:07 1/19/2038', time'9:19:29');

select addtime(timestamptz'03:14:08 1/19/2038', time'9:19:29');

select addtime(timestamptz'03:14:07 2/19/2038', time'9:19:29');

select addtime(timestamptz'03:14:07 1/20/2038', time'9:19:29');

select addtime(timestamptz'03:14:07 1/19/2039', time'9:19:29');

--TEST: ??
select addtime(timestamptz'03:14:07 PM 1/19/2038', time'9:19:29');

select addtime(timestamptz'0:0:0 PM 1969-01-01', time'9:19:29');

select addtime(timestamptz'11:03:22 PM 1864-01-23', time'9:19:29');

select addtime(timestamptz'2300-12-12 22:02:33', time'9:19:29');

select addtime(timestamptz'2020-23-11 03:14:66 pm', time'9:19:29');

select addtime(timestamptz'1970-10-101 0:0', time'9:19:29');

select addtime(timestamptz'1999/12/11 3:14:7 am', time'9:19:29');

select addtime(timestamptz'2010-4-31 3:14:7 am', time'9:19:29');



--TEST: 3. [error] out-of-range argument: datetimetz type
select addtime(datetimetz'2010-10 10:10:100.00 am', time'9:19:29');

select addtime(datetimetz'24:59:59.999 12/31/9999', time'9:19:29');

select addtime(datetimetz'23:60:59.999 12/31/9999', time'9:19:29');

select addtime(datetimetz'23:59:60.999 12/31/9999', time'9:19:29');

select addtime(datetimetz'23:59:59.1000 12/31/9999', time'9:19:29');

select addtime(datetimetz'23:59:59.999 13/31/9999', time'9:19:29');

select addtime(datetimetz'23:59:59.999 12/32/9999', time'9:19:29');

select addtime(datetimetz'23:59:59.999 12/31/10000', time'9:19:29');

select addtime(datetimetz'20:33:61.111 1990-10-19 ', time'9:19:29');

select addtime(datetimetz'2/31/2022 10:20:30.400', time'9:19:29');

select addtime(datetimetz'12/31/9999 23:59:59:999', time'9:19:29');

select addtime(datetimetz'0-12-12 23:59:59.999', time'9:19:29');




--TEST: 4. [error] out-of-range argument of time format
select addtime('10:10:100.00 am', time'9:19:29');

select addtime('24:59:59.999', time'9:19:29');

select addtime('23:60:59.999', time'9:19:29');

select addtime('23:59:60.999', time'9:19:29');

select addtime('23:60:59', time'9:19:29');

select addtime('188:59:59', time'9:19:29');
