--pass different formats of timestampltz/datetimeltz arguments

--1. pass different formats of timestampltz arguments
--select dayofweek(timestampltz'13:14:55 10/08');
select if(dayofweek(timestampltz'13:14:55 10/08/2014')=dayofweek(timestampltz '13:14:55 10/08/2014'),'ok','nok');

select dayofweek(timestampltz'2:22:22 8/12/2010 Asia/Seoul');

select dayofweek(timestampltz'09:03:22 PM 1988-08-08 Asia/Seoul');

select dayofweek(timestampltz'12/12/2033 10:20:55 Asia/Seoul');


--2. pass different formats of datetimeltz arguments
--select dayofweek(datetimeltz'13:14:55.123 10/08');
select if(dayofweek(datetimeltz'13:14:55 10/08/2014')=dayofweek(datetimeltz '13:14:55 10/08/2014'),'ok','nok');

select dayofweek(datetimeltz'2:22:22.333 8/12/2010');

select dayofweek(datetimeltz'09:03:22.012 PM 1988-08-08');

select dayofweek(datetimeltz'12/12/1556 10:20:55.567');
