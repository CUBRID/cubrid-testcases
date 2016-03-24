--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select day(date'2010-10-08');

select day(date'12-25');

select day(date'8/30');

select day(date'11/09/1864');



--2. pass different formats of timestamp arguments
select day(timestamp'13:14:55 10/08');

select day(timestamp'2:22:22 8/12/2010');

select day(timestamp'09:03:22 PM 1988-08-08');

select day(timestamp'12/12/1999 10:20:55');



--3. pass different formats of datetime arguments
select day(datetime'13:14:55.123 10/08');

select day(datetime'2:22:22.333 8/12/2010');

select day(datetime'09:03:22.012 PM 1988-08-08');

select day(datetime'12/12/1556 10:20:55.567');


