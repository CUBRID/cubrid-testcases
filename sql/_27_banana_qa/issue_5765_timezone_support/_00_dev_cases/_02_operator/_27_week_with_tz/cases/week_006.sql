--pass different formats of timestamptz/datetimetz arguments (2 params)


--1. pass different formats of timestamptz arguments
--select week(timestamptz'13:14:55 10/08', 4);
select if(week(timestampltz'13:14:55 10/08/2014', 4)=week(timestamptz'13:14:55 10/08/2014',4),'ok','nok');

select week(timestamptz'2:22:22 8/12/2010', 5);

select week(timestamptz'09:03:22 PM 1988-08-08', 6);

select week(timestamptz'12/12/2022 10:20:55', 7);



--2. pass different formats of datetimetz arguments
--select week(datetimetz'13:14:55.123 10/08', 0);
select if(week(datetimetz'13:14:55.123 10/08',0)=week(concat('10/08/',year(sysdate))),'ok','nok');

select week(datetimetz'2:22:22.333 8/12/2010', 1);

select week(datetimetz'09:03:22.012 PM 1988-08-08', 2);

select week(datetimetz'12/12/1556 10:20:55.567', 3);


