--pass different formats of string arguments


--1. string values of date format
select dayofmonth('2010-10-08');

select dayofmonth('12-25');

select dayofmonth('8/30');

select dayofmonth('11/09/1864');



--2. string values of timestamp format
select dayofmonth('13:14:55 10/08');

select dayofmonth('2:22:22 8/12/2010');

select dayofmonth('09:03:22 PM 1988-08-08');

select dayofmonth('12/12/1980 10:20:55');



--3. string values of datetime format
select dayofmonth('13:14:55.123 10/08');

select dayofmonth('2:22:22.333 8/12/2010');

select dayofmonth('09:03:22.012 PM 1988-08-08');

select dayofmonth('12/12/1556 10:20:55.567');


