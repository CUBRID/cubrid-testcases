-- pass different formats of timestamptz/datetimetz arguments


--2. pass different formats of timestamptz arguments
select date(timestamptz'2010-10-08 2:16:10');

select date(timestamptz'2009-1-09 4:30:01 am');

select date(timestamptz'1999-11-30 9:10:10 pm');

select date(timestamptz'13:14:55 10/08/2014');

select date(timestamptz'2:22:22 8/12/2010');

select date(timestamptz'09:03:22 PM 1988-08-08');

select date(timestamptz'12/12/1999 10:20:55');

--error
select date(timestamptz'12/12/1999 18:20:55 AM');



--3. pass different formats of datetimetz arguments
select date(datetimetz'13:14:55.123 10/08/2014');

select date(datetimetz'2:22:22.333 8/12/2010');

select date(datetimetz'09:03:22.012 PM 1988-08-08');

select date(datetimetz'12/12/1644 10:20:55.789');

--error
select date(datetimetz'12/12/1644 21:20:55.789 am');

