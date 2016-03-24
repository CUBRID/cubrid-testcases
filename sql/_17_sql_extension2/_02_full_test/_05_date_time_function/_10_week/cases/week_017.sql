--pass exceptional data of string type to the parameter (2 params)



--1. [error] exceptional argument of date format
select week('0000/000/00',);

select week('12\23\2009', null);

select week('01 2-2000', 0);

select week('1988-12-12-11', 2);

select week('aa/bb/cc', 3);



--2. [error] exceptional argument of timestamp format
select week('23:00:00 11/001', );

select week('04:14:07 1/0019/2011', null);

select week('03:15,07 1/19/1999', 1);

select week('03:14:08 hm 1/19/2010', 2);

select week('03:14:07 3\22\1998', 3);

select week('03:14:07 a/b/c', 4);

select week('11:03:22 PM 1993--01--23', null);

select week('2000=12=12 22:02:33', 5);

select week('2020-23-11 03:14:45pm', 22222);



--3. [error] exceptional argument of datetime format
select week('2010-10 10:10:00001.0000001 am', );

select week('20:59:59.999 0012/00031/1999', null);

select week('1::2::3.4 12/31/9999', 3);

select week('23:59:33:44:555 12/31/9999', 0);

select week('20:23:45.23 12\31\2000', -1000);

select week('20:23:45.23 a/b/c', 3030303);

select week('20:33:21.111 1990-10--19 ', ' ');

select week('2/12/2022 10:20:cc:400', 1);

select week('12/31/1989 23:59:59.123am', 4);


--4. [error] empty, null and unmatched number of argument
select week('', 2);

select week(null, null);

select week(' ', ' ');

select week(?, ?);

