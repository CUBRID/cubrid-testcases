--pass different formats of timestamptz/datetimetz arguments

--1. pass different formats of timestamptz arguments
select quarter(timestamptz'13:14:55 10/08 Europe/London');

select quarter(timestamptz'2:22:22 8/12/2010 Europe/Paris');

select quarter(timestamptz'09:03:22 PM 1988-08-08 Asia/Seoul');

select quarter(timestamptz'12/12/1988 10:20:55 Europe/Zurich');


--2. pass different formats of datetimetz arguments
select quarter(datetimetz'13:14:55.123 10/08 Europe/London');

select quarter(datetimetz'2:22:22.333 8/12/2010 Europe/Paris');

select quarter(datetimetz'09:03:22.012 PM 1988-08-08 Asia/Seoul');

select quarter(datetimetz'12/12/1556 10:20:55.567 Europe/Zurich');


