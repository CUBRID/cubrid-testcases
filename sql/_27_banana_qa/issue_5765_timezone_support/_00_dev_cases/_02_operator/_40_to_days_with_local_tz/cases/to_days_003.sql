--pass different formats of timestampltz/datetimeltz arguments

--1. pass different formats of timestampltz arguments
--select to_days(timestampltz'13:14:55 10/08');
select if(to_days(timestampltz'13:14:55 10/08/2014')=to_days(timestamptz'13:14:55 10/08/2014'),'ok','nok');

select to_days(timestampltz'2:22:22 8/12/2010');

select to_days(timestampltz'09:03:22 PM 1988-08-08');

select to_days(timestampltz'12/12/2033 10:20:55');



--2. pass different formats of datetimeltz arguments
--select to_days(datetimeltz'13:14:55.123 10/08');
select if(to_days(datetimeltz'13:14:55.123 10/08')=to_days(concat('10/08/',year(sysdate))),'ok','nok');

select to_days(datetimeltz'2:22:22.333 8/12/2010');

select to_days(datetimeltz'09:03:22.012 PM 1988-08-08');

select to_days(datetimeltz'12/12/1556 10:20:55.567');
