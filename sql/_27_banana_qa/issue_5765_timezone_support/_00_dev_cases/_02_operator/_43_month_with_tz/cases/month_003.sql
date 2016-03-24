--pass different formats of timestamptz/datetimetz arguments


--1. pass different formats of timestamptz arguments
select month(timestamptz'13:14:55 10/08');

select month(timestamptz'2:22:22 8/12/2010');

select month(timestamptz'09:03:22 PM 1988-08-08');

select month(timestamptz'12/12/2008 10:20:55');



--2. pass different formats of datetimetz arguments
select month(datetimetz'13:14:55.123 10/08');

select month(datetimetz'2:22:22.333 8/12/2010');

select month(datetimetz'09:03:22.012 PM 1988-08-08');

select month(datetimetz'12/12/1556 10:20:55.567');
