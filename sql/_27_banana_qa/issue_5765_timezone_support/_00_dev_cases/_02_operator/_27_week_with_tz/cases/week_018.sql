--pass exceptional data of timestamptz/datetimetz type to the parameter (2 params)

--1. [error] exceptional argument of timestamptz type
select week(timestamptz'23:00:00 11/001', );

select week(timestamptz'04:14:07 1/0019/2011', null);

select week(timestamptz'03:15,07 1/19/1999', 1);

select week(timestamptz'03:14:08 hm 1/19/2010', 2);

select week(timestamptz'03:14:07 3\22\1998', 3);

select week(timestamptz'03:14:07 a/b/c', 4);

select week(timestamptz'11:03:22 PM 1993--01--23', null);

select week(timestamptz'2000=12=12 22:02:33', 5);

select week(timestamptz'2020-23-11 03:14:45pm', 22222);



--2. [error] exceptional argument of datetimetz type
select week(datetimetz'2010-10 10:10:00001.0000001 am', );

select week(datetimetz'20:59:59.999 0012/00031/1999', null);

select week(datetimetz'1::2::3:4 12/31/9999', 3);

select week(datetimetz'23:59:33:44:555 12/31/9999', 0);

select week(datetimetz'20:23:45.23 12\31\2000', -1000);

select week(datetimetz'20:23:45.23 a/b/c', 3030303);

select week(datetimetz'20:33:21.111 1990-10--19 ', ' ');

select week(datetimetz'2/12/2022 10:20:cc:400', 1);

select week(datetimetz'12/31/1989 23:59:59.123am', 4);


--4. [error] empty, null and unmatched number of argument
select week(datetimetz' ', ' ');
