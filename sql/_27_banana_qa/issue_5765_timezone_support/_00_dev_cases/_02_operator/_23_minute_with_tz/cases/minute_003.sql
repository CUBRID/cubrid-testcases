-- pass different formats of timestamptz/datetimetz arguments


--2. pass different formats of timestamptz arguments
select minute(timestamptz'2010-10-08 2:16:10 Asia/Seoul');

select minute(timestamptz'2009-1-09 4:30:01 am Asia/Seoul');

select minute(timestamptz'1999-11-30 9:10:10 pm Asia/Seoul');

select minute(timestamptz'13:14:55 10/08 Asia/Seoul');

select minute(timestamptz'2:22:22 8/12/2010 Asia/Seoul');

select minute(timestamptz'09:03:22 PM 1988-08-08 Asia/Seoul');

select minute(timestamptz'12/12/1999 10:20:55 Asia/Seoul');



--3. pass different formats of datetimetz arguments
select minute(datetimetz'13:14:55.123 10/08 Asia/Seoul');

select minute(datetimetz'2:22:22.333 8/12/2010 Asia/Seoul');

select minute(datetimetz'09:03:22.012 PM 1988-08-08 Asia/Seoul');

select minute(datetimetz'12/12/1644 10:20:55.789 Asia/Seoul');
