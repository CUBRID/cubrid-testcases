--pass exceptional data of string type to the parameter



--1. [error] exceptional argument of date format
select week('0000/000/00');

select week('12\23\2009');

select week('01 2-2000');

select week('1988-12-12-11');

select week('aa/bb/cc');



--2. [error] exceptional argument of timestamp format
--select week('23:00:00 11/001');
select if(week('23:00:00 11/001')=week(concat('23:00:00 11/001/',year(sysdate))),'ok','nok');

select week('04:14:07 1/0019/2011');

select week('03:15,07 1/19/1999');

select week('03:14:08 hm 1/19/2010');

select week('03:14:07 3\22\1998');

select week('03:14:07 a/b/c');

select week('11:03:22 PM 1993--01--23');

select week('2000=12=12 22:02:33');

select week('2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime format
select week('2010-10 10:10:00001.0000001 am');

select week('20:59:59.999 0012/00031/1999');

select week('1::2::3:4 12/31/9999');

select week('23:59:33.44:555 12/31/9999');

select week('20:23:45.23 12\31\2000');

select week('20:23:45.23 a/b/c');

select week('20:33:21.111 1990-10--19 ');

select week('2/12/2022 10:20:cc:400');

select week('12/31/1989 23:59:59.123am');


--4. [error] empty, null and unmatched number of argument
select week();

select week(null);

select week('2010-10-10 12:34:33', 3, 5);

select week(?);

select week(?, ?);

select week;
