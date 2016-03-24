--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select month(date'2010-10-08');

select month(date'12-25');

select month(date'8/30');

select month(date'11/09/1864');



--2. pass different formats of timestamp arguments
select month(timestamp'13:14:55 10/08');

select month(timestamp'2:22:22 8/12/2010');

select month(timestamp'09:03:22 PM 1988-08-08');

select month(timestamp'12/12/2008 10:20:55');



--3. pass different formats of datetime arguments
select month(datetime'13:14:55.123 10/08');

select month(datetime'2:22:22.333 8/12/2010');

select month(datetime'09:03:22.012 PM 1988-08-08');

select month(datetime'12/12/1556 10:20:55.567');


