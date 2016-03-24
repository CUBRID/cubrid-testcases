--pass different formats of timestampltz/datetimeltz arguments


--1. pass different formats of timestampltz arguments
--select weekday(timestampltz'13:14:55 10/08');
select if(weekday(timestampltz'13:14:55 10/08/2014')=weekday(timestamptz'13:14:55 10/08/2014'),'ok','nok');

select weekday(timestampltz'2:22:22 8/12/2010');

select weekday(timestampltz'09:03:22 PM 1988-08-08');

select weekday(timestampltz'12/12/2033 10:20:55');


--2. pass different formats of datetimeltz arguments
--select weekday(datetimeltz'13:14:55.123 10/08');
select if(weekday(datetimeltz'13:14:55.123 10/08/2014')=weekday('10/08/2014'),'ok','nok');

select weekday(datetimeltz'2:22:22.333 8/12/2010');

select weekday(datetimeltz'09:03:22.012 PM 1988-08-08');

select weekday(datetimeltz'12/12/1556 10:20:55.567');
