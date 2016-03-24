--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select quarter(date'2010-10-08');

select quarter(date'12-25');

select quarter(date'8/30');

select quarter(date'11/09/1864');



--2. pass different formats of timestamp arguments
select quarter(timestamp'13:14:55 10/08');

select quarter(timestamp'2:22:22 8/12/2010');

select quarter(timestamp'09:03:22 PM 1988-08-08');

select quarter(timestamp'12/12/1988 10:20:55');



--3. pass different formats of datetime arguments
select quarter(datetime'13:14:55.123 10/08');

select quarter(datetime'2:22:22.333 8/12/2010');

select quarter(datetime'09:03:22.012 PM 1988-08-08');

select quarter(datetime'12/12/1556 10:20:55.567');


