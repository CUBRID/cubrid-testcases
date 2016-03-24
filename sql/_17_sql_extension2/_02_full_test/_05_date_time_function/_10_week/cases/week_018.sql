--pass exceptional data of date/time type to the parameter (2 params)



--1. [error] exceptional argument of date type
select week(date'0000/000/00',);

select week(date'12\23\2009', null);

select week(date'01 2-2000', 0);

select week(date'1988-12-12-11', 2);

select week(date'aa/bb/cc', 3);



--2. [error] exceptional argument of timestamp type
select week(timestamp'23:00:00 11/001', );

select week(timestamp'04:14:07 1/0019/2011', null);

select week(timestamp'03:15,07 1/19/1999', 1);

select week(timestamp'03:14:08 hm 1/19/2010', 2);

select week(timestamp'03:14:07 3\22\1998', 3);

select week(timestamp'03:14:07 a/b/c', 4);

select week(timestamp'11:03:22 PM 1993--01--23', null);

select week(timestamp'2000=12=12 22:02:33', 5);

select week(timestamp'2020-23-11 03:14:45pm', 22222);



--3. [error] exceptional argument of datetime type
select week(datetime'2010-10 10:10:00001.0000001 am', );

select week(datetime'20:59:59.999 0012/00031/1999', null);

select week(datetime'1::2::3:4 12/31/9999', 3);

select week(datetime'23:59:33:44:555 12/31/9999', 0);

select week(datetime'20:23:45.23 12\31\2000', -1000);

select week(datetime'20:23:45.23 a/b/c', 3030303);

select week(datetime'20:33:21.111 1990-10--19 ', ' ');

select week(datetime'2/12/2022 10:20:cc:400', 1);

select week(datetime'12/31/1989 23:59:59.123am', 4);


--4. [error] empty, null and unmatched number of argument
select week(date'', 2);

select week(datetime' ', ' ');


