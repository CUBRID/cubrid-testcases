--pass different formats of timestamptz/datetimetz arguments

--1. pass different formats of timestamptz arguments
--select dayofweek(timestamptz'13:14:55 10/08 Asia/Seoul');
select if(dayofweek(timestampltz'13:14:55 10/08/2014')=dayofweek(timestamptz '13:14:55 10/08/2014'),'ok','nok');

select dayofweek(timestamptz'2:22:22 8/12/2010 Asia/Seoul');

select dayofweek(timestamptz'09:03:22 PM 1988-08 Asia/Seoul');

select dayofweek(timestamptz'12/12/2033 10:20:55 Asia/Seoul');


--2. pass different formats of datetimetz arguments
--select dayofweek(datetimetz'13:14:55.123 10/08 Asia/Seoul');
select if(dayofweek(datetimetz'13:14:55 10/08/2014')=dayofweek(datetimeltz '13:14:55 10/08/2014'),'ok','nok');

select dayofweek(datetimetz'2:22:22.333 8/12/2010 Asia/Seoul');

select dayofweek(datetimetz'09:03:22.012 PM 1988-08-08 Asia/Seoul');

select dayofweek(datetimetz'12/12/1556 10:20:55.567 Asia/Seoul');
