--pass different formats of timestampltz/datetimeltz arguments


--1. pass different formats of timestampltz arguments
--select year(timestampltz'13:14:55 10/08');
select if(year(timestampltz'13:14:55 10/08')=year(sysdate),'ok','nok');

select year(timestampltz'2:22:22 8/12/2010');

select year(timestampltz'09:03:22 PM 1988-08-08');

select year(timestampltz'12/12/2033 10:20:55');



--2. pass different formats of datetimeltz arguments
--select year(datetimeltz'13:14:55.123 10/08');
select if(year(datetimeltz'13:14:55.123 10/08')=year(sysdate),'ok','nok');

select year(datetimeltz'2:22:22.333 8/12/2010');

select year(datetimeltz'09:03:22.012 PM 1988-08-08');

select year(datetimeltz'12/12/1556 10:20:55.567');
