--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select dayofmonth(date'2010-10-08');

select dayofmonth(date'12-25');

select dayofmonth(date'8/30');

select dayofmonth(date'11/09/1864');



--2. pass different formats of timestamp arguments
select dayofmonth(timestamp'13:14:55 10/08');

select dayofmonth(timestamp'2:22:22 8/12/2010');

select dayofmonth(timestamp'09:03:22 PM 1988-08-08');

select dayofmonth(timestamp'12/12/1988 10:20:55');



--3. pass different formats of datetime arguments
select dayofmonth(datetime'13:14:55.123 10/08');

select dayofmonth(datetime'2:22:22.333 8/12/2010');

select dayofmonth(datetime'09:03:22.012 PM 1988-08-08');

select dayofmonth(datetime'12/12/1556 10:20:55.567');


