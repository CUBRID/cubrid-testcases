--pass different formats of string arguments


--1. string values of date format
select dayofyear('2010-10-08');

--select dayofyear('12-25');
select if(dayofyear('12-25')=dayofyear(concat(year(sysdate),'-12-25')),'ok','nok');

--select dayofyear('8/30');
select if(dayofyear('8/30')=dayofyear(concat('8/30/',year(sysdate))),'ok','nok');

select dayofyear('11/09/1864');



--2. string values of timestamp format
--select dayofyear('13:14:55 10/08');
select if(dayofyear('13:14:55 10/08')=dayofyear(concat('13:14:55 10/08/',year(sysdate))),'ok','nok');

select dayofyear('2:22:22 8/12/2010');

select dayofyear('09:03:22 PM 1988-08-08');

select dayofyear('12/12/2022 10:20:55');



--3. string values of datetime format
--select dayofyear('13:14:55.123 10/08');
select if(dayofyear('13:14:55.123 10/08')=dayofyear(concat('13:14:55.123 10/08/',year(sysdate))),'ok','nok');

select dayofyear('2:22:22.333 8/12/2010');

select dayofyear('09:03:22.012 PM 1988-08-08');

select dayofyear('12/12/1556 10:20:55.567');


