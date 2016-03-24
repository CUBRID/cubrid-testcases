--pass different formats of timestamptz/datetimetz arguments


--1. pass different formats of timestamptz arguments
--select weekday(timestamptz'13:14:55 10/08');
select if(weekday(timestamptz'13:14:55 10/08/2014')=weekday(timestampltz'13:14:55 10/08/2014'),'ok','nok');

select weekday(timestamptz'2:22:22 8/12/2010');

select weekday(timestamptz'09:03:22 PM 1988-08-08');

select weekday(timestamptz'12/12/2033 10:20:55');


--2. pass different formats of datetimetz arguments
--select weekday(datetimetz'13:14:55.123 10/08');
select if(weekday(datetimetz'13:14:55.123 10/08/2014')=weekday('10/08/2014'),'ok','nok');

select weekday(datetimetz'2:22:22.333 8/12/2010');

select weekday(datetimetz'09:03:22.012 PM 1988-08-08');

select weekday(datetimetz'12/12/1556 10:20:55.567');
