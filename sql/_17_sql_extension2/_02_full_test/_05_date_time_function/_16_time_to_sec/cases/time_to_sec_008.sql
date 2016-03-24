--pass exceptional data of string type to the parameter



--1. [error] exceptional argument of time format
select time_to_sec('0000:000:00');

select time_to_sec('12:30:59 bm');

select time_to_sec('4.22:45 am');

select time_to_sec('13:24:33:44');

select time_to_sec('0009:34 pm');

select time_to_sec('aa:bb:cc');



--2. [error] exceptional argument of timestamp format
select time_to_sec('23:00:00 11/001');

select time_to_sec('04:14:07 1/0019/2011');

select time_to_sec('03:15,07 1/19/1999');

select time_to_sec('03:14:08 hm 1/19/2010');

select time_to_sec('03:14:07 3\22\1998');

select time_to_sec('03:14:07 a/b/c');

select time_to_sec('11:03:22 PM 1993--01--23');

select time_to_sec('2000=12=12 22:02:33');

select time_to_sec('2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime format
select time_to_sec('2010-10 10:10:00001:0000001 am');

select time_to_sec('20:59:59:999 0012/00031/1999');

select time_to_sec('1::2::3:4 12/31/9999');

select time_to_sec('23:59:33:44:555 12/31/9999');

select time_to_sec('20:23:45:23 12\31\2000');

select time_to_sec('20:23:45:23 a/b/c');

select time_to_sec('20:33:21:111 1990-10--19 ');

select time_to_sec('2/12/2022 10:20:cc:400');

select time_to_sec('12/31/1989 23:59:59:123am');


--4. [error] empty, null and unmatched number of argument
select time_to_sec();

select time_to_sec(null);

select time_to_sec('2010-10-10 12:34:33', 3);

select time_to_sec(?);

select time_to_sec;
