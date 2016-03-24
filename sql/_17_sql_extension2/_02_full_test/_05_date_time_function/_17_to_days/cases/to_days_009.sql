--pass exceptional data of time/timestamp/datetime type to the parameter


--1. [error] exceptional argument of date type
select to_days(date'000/000/000');

select to_days(date'12\30\2009');

select to_days(date'1999-10=21');

select to_days(date'12/14/2012/33');

select to_days(date'-11/23/1898');

select to_days(date'aa-bb-cc');



--2. [error] exceptional argument of timestamp type

--select to_days(timestamp'23:00:00 11/001');
select if(to_days(timestamp(concat('23:00:00 11/001/',year(sysdate))))=to_days(timestamp'23:00:00 11/001'), 'ok','nok');

select to_days(timestamp'04:14:07 1/0019/2011');

select to_days(timestamp'03:15,07 1/19/1999');

select to_days(timestamp'03:14:08 hm 1/19/2010');

select to_days(timestamp'03:14:07 3\22\1998');

select to_days(timestamp'03:14:07 a/b/c');

select to_days(timestamp'11:03:22 PM 1993--01--23');

select to_days(timestamp'2000=12=12 22:02:33');

select to_days(timestamp'2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime type
select to_days(datetime'2010-10 10:10:00001.0000001 am');

select to_days(datetime'20:59:59.999 0012/00031/1999');

select to_days(datetime'1::2::3.4 12/31/9999');

select to_days(datetime'23:59:33.44:555 12/31/9999');

select to_days(datetime'20:23:45.23 12\31\2000');

select to_days(datetime'20:23:45.23 a/b/c');

select to_days(datetime'20:33:21.111 1990-10--19 ');

select to_days(datetime'2/12/2022 10:20:cc:400');

select to_days(datetime'12/31/1989 23:59:59.123am');


--4. [error] unmatched number of argument
select to_days(timestamp'2010-10-10 12:34:33', 3);

select to_days(date'2010-10-28', 555);

select to_days(datetime'10:10:10:100 12/22/2022', 'aaa', 'bbb');
