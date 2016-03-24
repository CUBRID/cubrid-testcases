--TEST: pass out-of-range data of string type to the 2nd parameter



--TEST: 1. [error] out-of-range argument of date format
select addtime(time'14:59:59', '13/11/1989');

select addtime(time'14:59:59', '05/33/1901');

select addtime(time'14:59:59', '2/20/10000');

select addtime(time'14:59:59', '0-1-1');

select addtime(time'14:59:59', '1999-04-31');

select addtime(time'14:59:59', '03-02-31');

select addtime(time'14:59:59', '00/00/0000');




--TEST: 2. [error] out-of-range argument of timestamp format
select addtime(time'14:59:59', '23:00:00 13/01');

select addtime(time'14:59:59', '04:14:07 1/19/2038');

select addtime(time'14:59:59', '03:15:07 1/19/2038');

select addtime(time'14:59:59', '03:14:08 1/19/2038');

select addtime(time'14:59:59', '03:14:07 2/19/2038');

select addtime(time'14:59:59', '03:14:07 1/20/2038');

select addtime(time'14:59:59', '03:14:07 1/19/2039');

select addtime(time'14:59:59', '03:14:07 PM 1/19/2038');

select addtime(time'14:59:59', '0:0:0 PM 1969-01-01');

select addtime(time'14:59:59', '11:03:22 PM 1864-01-23');

select addtime(time'14:59:59', '2300-12-12 22:02:33');

select addtime(time'14:59:59', '2020-23-11 03:14:66 pm');

select addtime(time'14:59:59', '1970-10-101 0:0');

select addtime(time'14:59:59', '1999/12/11 3:14:7 am');

select addtime(time'14:59:59', '2010-4-31 3:14:7 am');



--TEST: 3. [error] out-of-range argument of datetime format
select addtime(time'14:59:59', '2010-10 10:10:100.00 am');

select addtime(time'14:59:59', '24:59:59.999 12/31/9999');

select addtime(time'14:59:59', '23:60:59.999 12/31/9999');

select addtime(time'14:59:59', '23:59:60.999 12/31/9999');

select addtime(time'14:59:59', '23:59:59.1000 12/31/9999');

select addtime(time'14:59:59', '23:59:59.999 13/31/9999');

select addtime(time'14:59:59', '23:59:59.999 12/32/9999');

select addtime(time'14:59:59', '23:59:59.999 12/31/10000');

select addtime(time'14:59:59', '20:33:61.111 1990-10-19 ');

select addtime(time'14:59:59', '2/31/2022 10:20:30.400');

select addtime(time'14:59:59', '12/31/9999 23:59:59.999');

select addtime(time'14:59:59', '0-12-12 23:59:59.999');




--TEST: 4. [error] out-of-range argument of time format
select addtime(time'9:19:29', '10:10:100.00 am');

select addtime(time'9:19:29', '24:59:59.999');

select addtime(time'9:19:29', '23:60:59.999');

select addtime(time'9:19:29', '23:59:60.999');

select addtime(time'9:19:29', '23:60:59');

select addtime(time'9:19:29', '188:59:59');




