--pass different formats of timestamptz/datetimetz arguments

--1. pass different formats of timestamptz arguments
--select to_days(timestamptz'13:14:55 10/08');
select if(to_days(timestamptz'13:14:55 10/08/2014')=to_days(timestampltz'13:14:55 10/08/2014'),'ok','nok');

select to_days(timestamptz'2:22:22 8/12/2010');

select to_days(timestamptz'09:03:22 PM 1988-08-08');

select to_days(timestamptz'12/12/2033 10:20:55');



--2. pass different formats of datetimetz arguments
--select to_days(datetimetz'13:14:55.123 10/08');
select if(to_days(datetimetz'13:14:55.123 10/08')=to_days(concat('10/08/',year(sysdate))),'ok','nok');

select to_days(datetimetz'2:22:22.333 8/12/2010');

select to_days(datetimetz'09:03:22.012 PM 1988-08-08');

select to_days(datetimetz'12/12/1556 10:20:55.567');
