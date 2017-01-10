--pass different formats of timestamptz/datetimetz arguments


--1. pass different formats of timestamptz arguments
--select week(timestamptz'13:14:55 10/08');
select if( abs(week(timestamptz'13:14:55 10/08')-week(timestamptz'13:14:55 10/08/2014')) in (0,1),'ok','nok');

select week(timestamptz'2:22:22 8/12/2010');

select week(timestamptz'09:03:22 PM 1988-08-08');

select week(timestamptz'12/12/2033 10:20:55');



--2. pass different formats of datetimetz arguments
--select week(datetimetz'13:14:55.123 10/08');
select if(week(datetimetz'13:14:55.123 10/08')=week(concat('10/08/',year(sysdate))),'ok','nok');

select week(datetimetz'2:22:22.333 8/12/2010');

select week(datetimetz'09:03:22.012 PM 1988-08-08');

select week(datetimetz'12/12/1556 10:20:55.567');


