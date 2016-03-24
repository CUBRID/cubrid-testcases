--pass different formats of string arguments


--1. string values of date format
select weekday('2010-10-08');

--?? pass date withour year
--select weekday('12-25');
select if(weekday('12-25')=weekday(concat(year(sysdate),'-12-25')),'ok','nok');

--select weekday('8/30');
select if(weekday('8/30')=weekday(concat('8/30/',year(sysdate))),'ok','nok');

select weekday('11/09/1864');



--2. string values of timestamp format
--select weekday('13:14:55 10/08');
select if(weekday('13:14:55 10/08')=weekday(concat('13:14:55 10/08/',year(sysdate))),'ok','nok');

select weekday('2:22:22 8/12/2010');

select weekday('09:03:22 PM 1988-08-08');

select weekday('12/12/2022 10:20:55');



--3. string values of datetime format
--select weekday('13:14:55.123 10/08');
select if(weekday('13:14:55.123 10/08')=weekday(concat('13:14:55.123 10/08/',year(sysdate))),'ok','nok');

select weekday('2:22:22.333 8/12/2010');

select weekday('09:03:22.012 PM 1988-08-08');

select weekday('12/12/1556 10:20:55.567');


