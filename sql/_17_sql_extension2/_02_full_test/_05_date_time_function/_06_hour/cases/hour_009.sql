--pass exceptional data of time/timestamp/datetime type to the parameter


--1. [error] exceptional argument of time type
select hour(time'0000:000:00');

select hour(time'12:30:59 bm');

select hour(time'4.22:45 am');

select hour(time'13:24:33:44');

select hour(time'0009:34 pm');

select hour(time'aa:bb:cc');



--2. [error] exceptional argument of timestamp type
select hour(timestamp'23:00:00 11/001');

select hour(timestamp'04:14:07 1/0019/2011');

select hour(timestamp'03:15,07 1/19/1999');

select hour(timestamp'03:14:08 hm 1/19/2010');

select hour(timestamp'03:14:07 3\22\1998');

select hour(timestamp'03:14:07 a/b/c');

select hour(timestamp'11:03:22 PM 1993--01--23');

select hour(timestamp'2000=12=12 22:02:33');

select hour(timestamp'2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime type
select hour(datetime'2010-10 10:10:00001.0000001 am');

select hour(datetime'20:59:59.999 0012/00031/1999');

select hour(datetime'1::2::3.4 12/31/9999');

select hour(datetime'23:59:33:44.555 12/31/9999');

select hour(datetime'20:23:45.23 12\31\2000');

select hour(datetime'20:23:45.23 a/b/c');

select hour(datetime'20:33:21.111 1990-10--19 ');

select hour(datetime'2/12/2022 10:20:cc:400');

select hour(datetime'12/31/1989 23:59:59:123am');


--4. [error] unmatched number of argument
select hour(timestamp'2010-10-10 12:34:33', 3);

select hour(time'22:33:44', 555);

select hour(datetime'10:10:10:100 12/22/2022', 'aaa', 'bbb');
