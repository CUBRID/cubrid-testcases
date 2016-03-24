--pass exceptional data of string type to the parameter



--1. [error] exceptional argument of time format
select second('0000:000:00');

select second('12:30:59 bm');

select second('4.22:45 am');

select second('13:24:33:44');

select second('0009:34 pm');

select second('aa:bb:cc');



--2. [error] exceptional argument of timestamp format
select second('23:00:00 11/001');

select second('04:14:07 1/0019/2011');

select second('03:15,07 1/19/1999');

select second('03:14:08 hm 1/19/2010');

select second('03:14:07 3\22\1998');

select second('03:14:07 a/b/c');

select second('11:03:22 PM 1993--01--23');

select second('2000=12=12 22:02:33');

select second('2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime format
select second('2010-10 10:10:00001:0000001 am');

select second('20:59:59:999 0012/00031/1999');

select second('1::2::3:4 12/31/9999');

select second('23:59:33:44:555 12/31/9999');

select second('20:23:45:23 12\31\2000');

select second('20:23:45:23 a/b/c');

select second('20:33:21:111 1990-10--19 ');

select second('2/12/2022 10:20:cc:400');

select second('12/31/1989 23:59:59:123am');


--4. [error] empty, null and unmatched number of argument
select second();

select second(null);

select second('2010-10-10 12:34:33', 3);

select second(?);

select second;
