--pass different formats of string arguments


--1. string values of date format
select year('2010-10-08');

--select year('12-25');
select if(year('12-25')=year(sysdate),'ok','nok');

--select year('8/30');
select if(year('8/30')=year(sysdate),'ok','nok');

select year('11/09/1864');



--2. string values of timestamp format
--select year('13:14:55 10/08');
select if(year('13:14:55 10/08')=year(sysdate),'ok','nok');

select year('2:22:22 8/12/2010');

select year('09:03:22 PM 1988-08-08');

select year('12/12/2022 10:20:55');



--3. string values of datetime format
--select year('13:14:55.123 10/08');
select if(year('13:14:55.123 10/08')=year(sysdate),'ok','nok');

select year('2:22:22.333 8/12/2010');

select year('09:03:22.012 PM 1988-08-08');

select year('12/12/1556 10:20:55.567');


