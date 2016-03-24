--pass different formats of timestamptz/datetimetz arguments


--1. pass different formats of timestamptz arguments
--select year(timestamptz'13:14:55 10/08');
select if(year(timestamptz'13:14:55 10/08')=year(sysdate),'ok','nok');

select year(timestamptz'2:22:22 8/12/2010');

select year(timestamptz'09:03:22 PM 1988-08-08');

select year(timestamptz'12/12/2033 10:20:55');



--2. pass different formats of datetimetz arguments
--select year(datetimetz'13:14:55.123 10/08');
select if(year(datetimetz'13:14:55.123 10/08')=year(sysdate),'ok','nok');

select year(datetimetz'2:22:22.333 8/12/2010');

select year(datetimetz'09:03:22.012 PM 1988-08-08');

select year(datetimetz'12/12/1556 10:20:55.567');
