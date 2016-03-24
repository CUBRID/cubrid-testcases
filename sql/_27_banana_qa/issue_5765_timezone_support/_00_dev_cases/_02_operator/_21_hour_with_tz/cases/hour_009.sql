--pass exceptional data of timetz/timestamptz/datetimetz type to the parameter


--2. [error] exceptional argument of timestamptz type
select hour(timestamptz'23:00:00 11/001 Asia/Seoul');

select hour(timestamptz'04:14:07 1/0019/2011 Asia/Seoul');

select hour(timestamptz'03:15,07 1/19/1999 Asia/Seoul');

select hour(timestamptz'03:14:08 hm 1/19/2010 Asia/Seoul');

select hour(timestamptz'03:14:07 3\22\1998 Asia/Seoul');

select hour(timestamptz'03:14:07 a/b/c Asia/Seoul');

select hour(timestamptz'11:03:22 PM 1993--01--23 Asia/Seoul');

select hour(timestamptz'2000=12=12 22:02:33 Asia/Seoul');

select hour(timestamptz'2020-23-11 03:14:45pm Asia/Seoul');



--3. [error] exceptional argument of datetimetz type
select hour(datetimetz'2010-10 10:10:00001.0000001 am Asia/Seoul');

select hour(datetimetz'20:59:59.999 0012/00031/1999 Asia/Seoul');

select hour(datetimetz'1::2::3.4 12/31/9999 Asia/Seoul');

select hour(datetimetz'23:59:33:44.555 12/31/9999 Asia/Seoul');

select hour(datetimetz'20:23:45.23 12\31\2000 Asia/Seoul');

select hour(datetimetz'20:23:45.23 a/b/c Asia/Seoul');

select hour(datetimetz'20:33:21.111 1990-10--19  Asia/Seoul');

select hour(datetimetz'2/12/2022 10:20:cc:400 Asia/Seoul');

select hour(datetimetz'12/31/1989 23:59:59:123am Asia/Seoul');


--4. [error] unmatched number of argument
select hour(timestamptz'2010-10-10 12:34:33 Asia/Seoul', 3);

select hour(datetimetz'10:10:10:100 12/22/2022 Asia/Seoul', 'aaa', 'bbb');
