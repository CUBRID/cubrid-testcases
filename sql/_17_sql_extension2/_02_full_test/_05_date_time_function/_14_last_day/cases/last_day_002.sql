--pass different formats of string arguments


--1. string values of date format
select last_day('2010-10-08');

--select last_day('12-25');
select if(last_day(concat(year(sysdate),'-12-25'))=last_day('12-25'),'ok','nok');

--select last_day('8/30');
select if(last_day(concat('8/30/',year(sysdate)))=last_day('8/30'),'ok','nok');

select last_day('11/09/1864');



--2. string values of timestamp format
--select last_day('13:14:55 10/08');
select if(last_day(concat('13:14:55 10/08/',year(sysdate)))=last_day('13:14:55 10/08'),'ok','nok');

select last_day('2:22:22 8/12/2010');

select last_day('09:03:22 PM 1988-08-08');

select last_day('12/12/2022 10:20:55');



--3. string values of datetime format
--select last_day('13:14:55.123 10/08');
select if(last_day(concat('13:14:55.123 10/08/',year(sysdate)))=last_day('13:14:55.123 10/08'),'ok','nok');

select last_day('2:22:22.333 8/12/2010');

select last_day('09:03:22.012 PM 1988-08-08');

select last_day('12/12/1556 10:20:55.567');


