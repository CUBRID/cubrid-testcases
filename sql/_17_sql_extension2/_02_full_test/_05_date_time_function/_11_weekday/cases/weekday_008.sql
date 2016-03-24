--pass exceptional data of string type to the parameter



--1. [error] exceptional argument of date format
select weekday('0000/000/00');

select weekday('12\23\2009');

select weekday('01 2-2000');

select weekday('1988-12-12-11');

select weekday('aa/bb/cc');



--2. [error] exceptional argument of timestamp format
--select weekday('23:00:00 11/001');
select if(weekday('23:00:00 11/001')=weekday(concat('23:00:00 11/001/',year(sysdate))),'ok','nok');

select weekday('04:14:07 1/0019/2011');

select weekday('03:15,07 1/19/1999');

select weekday('03:14:08 hm 1/19/2010');

select weekday('03:14:07 3\22\1998');

select weekday('03:14:07 a/b/c');

select weekday('11:03:22 PM 1993--01--23');

select weekday('2000=12=12 22:02:33');

select weekday('2020-23-11 03:14:45pm');



--3. [error] exceptional argument of datetime format
select weekday('2010-10 10:10:00001.0000001 am');

select weekday('20:59:59.999 0012/00031/1999');

select weekday('1::2::3:4 12/31/9999');

select weekday('23:59:33:44:555 12/31/9999');

select weekday('20:23:45.23 12\31\2000');

select weekday('20:23:45.23 a/b/c');

select weekday('20:33:21.111 1990-10--19 ');

select weekday('2/12/2022 10:20:cc:400');

select weekday('12/31/1989 23:59:59:123am');


--4. [error] empty, null and unmatched number of argument
select weekday();

select weekday(null);

select weekday('2010-10-10 12:34:33', 3);

select weekday(?);

select weekday;
