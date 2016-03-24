--pass exceptional data of time/timestamp/datetime type to the parameter


--1. [error] exceptional argument of date type
select dayofweek(date'000/000/000');

select dayofweek(date'12\30\2009');

select dayofweek(date'1999-10=21');

select dayofweek(date'12/14/2012/33');

select dayofweek(date'-11/23/1898');

select dayofweek(date'aa-bb-cc');



--2. [error] exceptional argument of timestamp type
--select dayofweek(timestamp'23:00:00 11/001');
select if(dayofweek(timestamp'23:00:00 11/001')=dayofweek(timestamp(concat('23:00:00 11/001/',year(sysdate)))),'ok','nok');

select dayofweek(timestamp'04:14:07 1/0019/2011');

select dayofweek(timestamp'03:15,07 1/19/1999');

select dayofweek(timestamp'03:14:08 hm 1/19/2010');

select dayofweek(timestamp'03:14:07 3\22\1998');

select dayofweek(timestamp'03:14:07 a/b/c');

select dayofweek(timestamp'11:03:22 PM 1993--01--23');

select dayofweek(timestamp'2000=12=12 22:02:33');

select dayofweek(timestamp'2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime type
select dayofweek(datetime'2010-10 10:10:00001.0000001 am');

select dayofweek(datetime'20:59:59.999 0012/00031/1999');

select dayofweek(datetime'1::2::3.4 12/31/9999');

select dayofweek(datetime'23:59:33.44:555 12/31/9999');

select dayofweek(datetime'20:23:45.23 12\31\2000');

select dayofweek(datetime'20:23:45.23 a/b/c');

select dayofweek(datetime'20:33:21.111 1990-10--19 ');

select dayofweek(datetime'2/12/2022 10:20:cc:400');

select dayofweek(datetime'12/31/1989 23:59:59.123am');


--4. [error] unmatched number of argument
select dayofweek(timestamp'2010-10-10 12:34:33', 3);

select dayofweek(date'2010-10-28', 555);

select dayofweek(datetime'10:10:10:100 12/22/2022', 'aaa', 'bbb');
