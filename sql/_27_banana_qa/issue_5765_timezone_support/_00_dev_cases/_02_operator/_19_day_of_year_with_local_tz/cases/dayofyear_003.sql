--pass different formats of timestampltz/datetimeltz arguments

--1. pass different formats of timestampltz arguments
--select dayofyear(timestampltz'13:14:55 10/08');
select if(dayofyear(timestampltz'13:14:55 2/28')=dayofyear(timestampltz '13:14:55 2/28/2014'),'ok','nok');

select dayofyear(timestampltz'2:22:22 8/12/2010');

select dayofyear(timestampltz'09:03:22 PM 1988-08-08');

select dayofyear(timestampltz'12/12/2033 10:20:55');


--2. pass different formats of datetimeltz arguments
--select dayofyear(datetimeltz'13:14:55.123 10/08');
select if(dayofyear(datetimeltz'13:14:55.123 2/28')=dayofyear('2/28/2014'),'ok','nok');

select dayofyear(datetimeltz'2:22:22.333 8/12/2010');

select dayofyear(datetimeltz'09:03:22.012 PM 1988-08-08');

select dayofyear(datetimeltz'12/12/1556 10:20:55.567');
