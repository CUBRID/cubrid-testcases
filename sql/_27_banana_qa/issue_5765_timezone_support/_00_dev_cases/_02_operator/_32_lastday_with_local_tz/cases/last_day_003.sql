--pass different formats of timestampltz/datetimeltz arguments

--1. pass different formats of timestampltz arguments
--select last_day(timestampltz'13:14:55 10/08');
select if(last_day(timestampltz'13:14:55 10/08/2014')=last_day(timestamptz'13:14:55 10/08/2014'),'ok','nok');

select last_day(timestampltz'2:22:22 8/12/2010');

select last_day(timestampltz'09:03:22 PM 1988-08-08');

select last_day(timestampltz'12/12/2033 10:20:55');



--2. pass different formats of datetimeltz arguments
--select last_day(datetimeltz'13:14:55.123 10/08');
select if(last_day(datetimeltz'13:14:55.123 10/08')=last_day(concat('10/08/',year(sysdate))),'ok','nok');

select last_day(datetimeltz'2:22:22.333 8/12/2010');

select last_day(datetimeltz'09:03:22.012 PM 1988-08-08');

select last_day(datetimeltz'12/12/1556 10:20:55.567');
