--pass exceptional data of timestamptz/datetimetz type to the parameter

--1. [error] exceptional argument of timestamptz type
--select year(timestamptz'23:00:00 11/001');
select if(year(timestamptz'23:00:00 11/001')=year(sysdate),'ok','nok');

select year(timestamptz'04:14:07 1/0019/2011');

select year(timestamptz'03:15,07 1/19/1999');

select year(timestamptz'03:14:08 hm 1/19/2010');

select year(timestamptz'03:14:07 3\22\1998');

select year(timestamptz'03:14:07 a/b/c');

select year(timestamptz'11:03:22 PM 1993--01--23');

select year(timestamptz'2000=12=12 22:02:33');

select year(timestamptz'2020-23-11 03:14:45pm');



--2. [error] exceptional argument of datetimetz type
select year(datetimetz'2010-10 10:10:00001:0000001 am');

select year(datetimetz'20:59:59:999 0012/00031/1999');

select year(datetimetz'1::2::3:4 12/31/9999');

select year(datetimetz'23:59:33:44:555 12/31/9999');

select year(datetimetz'20:23:45:23 12\31\2000');

select year(datetimetz'20:23:45:23 a/b/c');

select year(datetimetz'20:33:21:111 1990-10--19 ');

select year(datetimetz'2/12/2022 10:20:cc:400');

select year(datetimetz'12/31/1989 23:59:59:123am');


--3. [error] unmatched number of argument
select year(timestamptz'2010-10-10 12:34:33', 3);
select year(datetimetz'10:10:10:100 12/22/2022', 'aaa', 'bbb');
