--pass different formats of timestamptz/datetimetz arguments

--1. pass different formats of timestamptz arguments
--select dayofyear(timestamptz'13:14:55 10/08');
select if(dayofyear(timestamptz'13:14:55 2/28')=dayofyear(timestamptz '13:14:55 2/28/2014'),'ok','nok');

select dayofyear(timestamptz'2:22:22 8/12/2010 Asia/Seoul');

select dayofyear(timestamptz'09:03:22 PM 1988-08-08 Asia/Seoul');

select dayofyear(timestamptz'12/12/2033 10:20:55 Asia/Seoul');


--2. pass different formats of datetimetz arguments
--select dayofyear(datetimetz'13:14:55.123 10/08');
select if(dayofyear(datetimetz'13:14:55.123 2/28')=dayofyear('2/28/2014'),'ok','nok');

select dayofyear(datetimetz'2:22:22.333 8/12/2010 Asia/Seoul');

select dayofyear(datetimetz'09:03:22.012 PM 1988-08-08 Asia/Seoul');

select dayofyear(datetimetz'12/12/1556 10:20:55.567 Asia/Seoul');
