-- pass different formats of timetz/timestamptz/datetimetz arguments


--1. pass different formats of timetz arguments
select hour(time'3:15:17 ');

select hour(time'8:19:34 AM ');

select hour(time'13:11:14 pm ');

select hour(time'12:30 ');

--error
select hour(time'15:30 am ');


--2. pass different formats of  arguments
select hour(timestamptz'2010-10-08 2:16:10 Asia/Seoul');

select hour(timestamptz'2009-1-09 4:30:01 am Asia/Seoul');

select hour(timestamptz'1999-11-30 9:10:10 pm Asia/Seoul');

select hour(timestamptz'13:14:55 10/08 Asia/Seoul');

select hour(timestamptz'2:22:22 8/12/2010 Asia/Seoul');

select hour(timestamptz'09:03:22 PM 1988-08-08 Asia/Seoul');

select hour(timestamptz'12/12/1999 10:20:55 Asia/Seoul');



--3. pass different formats of datetimetz arguments
select hour(datetimetz'13:14:55.123 10/08 Asia/Seoul');

select hour(datetimetz'2:22:22.333 8/12/2010 Asia/Seoul');

select hour(datetimetz'09:03:22.012 PM 1988-08-08 Asia/Seoul');

select hour(datetimetz'12/12/1644 10:20:55.789 Asia/Seoul');
