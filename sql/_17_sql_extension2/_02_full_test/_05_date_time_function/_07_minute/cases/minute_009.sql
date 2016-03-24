--pass exceptional data of time/timestamp/datetime type to the parameter


--1. [error] exceptional argument of time type
select minute(time'0000:000:00');

select minute(time'12:30:59 bm');

select minute(time'4.22:45 am');

select minute(time'13:24:33:44');

select minute(time'0009:34 pm');

select minute(time'aa:bb:cc');



--2. [error] exceptional argument of timestamp type
select minute(timestamp'23:00:00 11/001');

select minute(timestamp'04:14:07 1/0019/2011');

select minute(timestamp'03:15,07 1/19/1999');

select minute(timestamp'03:14:08 hm 1/19/2010');

select minute(timestamp'03:14:07 3\22\1998');

select minute(timestamp'03:14:07 a/b/c');

select minute(timestamp'11:03:22 PM 1993--01--23');

select minute(timestamp'2000=12=12 22:02:33');

select minute(timestamp'2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime type
select minute(datetime'2010-10 10:10:00001.0000001 am');

select minute(datetime'20:59:59.999 0012/00031/1999');

select minute(datetime'1::2::3:4 12/31/9999');

select minute(datetime'23:59:33.44:555 12/31/9999');

select minute(datetime'20:23:45.23 12\31\2000');

select minute(datetime'20:23:45.23 a/b/c');

select minute(datetime'20:33:21.111 1990-10--19 ');

select minute(datetime'2/12/2022 10:20:cc.400');

select minute(datetime'12/31/1989 23:59:59:123am');


--4. [error] unmatched number of argument
select minute(timestamp'2010-10-10 12:34:33', 3);

select minute(time'22:33:44', 555);

select minute(datetime'10:10:10:100 12/22/2022', 'aaa', 'bbb');
