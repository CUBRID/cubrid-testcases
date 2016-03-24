--pass different formats of timestamptz/datetimetz arguments


--2. pass different formats of timestamptz arguments
select day(timestamptz'13:14:55 10/08');

select day(timestamptz'2:22:22 8/12/2010');

select day(timestamptz'09:03:22 PM 1988-08-08');

select day(timestamptz'12/12/1999 10:20:55');



--3. pass different formats of datetimetz arguments
select day(datetimetz'13:14:55.123 10/08');

select day(datetimetz'2:22:22.333 8/12/2010');

select day(datetimetz'09:03:22.012 PM 1988-08-08');

select day(datetimetz'12/12/1556 10:20:55.567');
