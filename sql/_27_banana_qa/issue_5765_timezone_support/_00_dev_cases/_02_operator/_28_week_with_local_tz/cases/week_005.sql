--pass different formats of timestampltz/datetimeltz arguments


--1. pass different formats of timestampltz arguments
--select week(timestampltz'13:14:55 10/08');
select if( abs ( week(timestampltz'13:14:55 10/08') - week(timestampltz'13:14:55 10/08/2014')) in (0,1),'ok','nok');

select week(timestampltz'2:22:22 8/12/2010');

select week(timestampltz'09:03:22 PM 1988-08-08');

select week(timestampltz'12/12/2033 10:20:55');



--2. pass different formats of datetimeltz arguments
--select week(datetimeltz'13:14:55.123 10/08');
select if(week(datetimeltz'13:14:55.123 10/08')=week(concat('10/08/',year(sysdate))),'ok','nok');

select week(datetimeltz'2:22:22.333 8/12/2010');

select week(datetimeltz'09:03:22.012 PM 1988-08-08');

select week(datetimeltz'12/12/1556 10:20:55.567');
