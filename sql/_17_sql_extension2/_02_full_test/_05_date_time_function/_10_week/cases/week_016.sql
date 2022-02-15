--pass exceptional data of time/timestamp/datetime type to the parameter


--1. [error] exceptional argument of date type
select week(date'000/000/000');

select week(date'12\30\2009');

select week(date'1999-10=21');

select week(date'12/14/2012/33');

select week(date'-11/23/1898');

select week(date'aa-bb-cc');



--2. [error] exceptional argument of timestamp type
--select week(timestamp'23:00:00 11/001');
select if(week(timestamp'23:00:00 11/001')=week(timestamp(concat('23:00:00 11/001/',year(sysdate)))),'ok','nok');

select week(timestamp'04:14:07 1/0019/2011');

select week(timestamp'03:15,07 1/19/1999');

select week(timestamp'03:14:08 hm 1/19/2010');

select week(timestamp'03:14:07 3\22\1998');

select week(timestamp'03:14:07 a/b/c');

select week(timestamp'11:03:22 PM 1993--01--23');

select week(timestamp'2000=12=12 22:02:33');

select week(timestamp'2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime type
select week(datetime'2010-10 10:10:00001.0000001 am');

select week(datetime'20:59:59.999 0012/00031/1999');

select week(datetime'1::2::3.4 12/31/9999');

select week(datetime'23:59:33:44:555 12/31/9999');

select week(datetime'20:23:45.23 12\31\2000');

select week(datetime'20:23:45.23 a/b/c');

select week(datetime'20:33:21.111 1990-10--19 ');

select week(datetime'2/12/2022 10:20:cc.400');

select week(datetime'12/31/1989 23:59:59.123am');


--4. [error] unmatched number of argument
select week(timestamp'2010-10-10 12:34:33', 3, 888);

select week(date'2010-10-28', 555, 'a');

select week(datetime'10:10:10.100 12/22/2022', 'aaa', 'bbb');
