--pass exceptional data of string type to the parameter



--1. [error] exceptional argument of date format
select year('0000/000/00');

select year('12\23\2009');

select year('01 2-2000');

select year('1988-12-12-11');

select year('aa/bb/cc');



--2. [error] exceptional argument of timestamp format
--select year('23:00:00 11/001');
select if(year('23:00:00 11/001')=year(sysdate),'ok','nok');

select year('04:14:07 1/0019/2011');

select year('03:15,07 1/19/1999');

select year('03:14:08 hm 1/19/2010');

select year('03:14:07 3\22\1998');

select year('03:14:07 a/b/c');

select year('11:03:22 PM 1993--01--23');

select year('2000=12=12 22:02:33');

select year('2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime format
select year('2010-10 10:10:00001:0000001 am');

select year('20:59:59:999 0012/00031/1999');

select year('1::2::3:4 12/31/9999');

select year('23:59:33:44:555 12/31/9999');

select year('20:23:45:23 12\31\2000');

select year('20:23:45:23 a/b/c');

select year('20:33:21:111 1990-10--19 ');

select year('2/12/2022 10:20:cc:400');

select year('12/31/1989 23:59:59:123am');


--4. [error] empty, null and unmatched number of argument
select year();

select year(null);

select year('2010-10-10 12:34:33', 3);

select year(?);

select year;
