--pass different formats of string arguments


--1. string values of date format
select week('2010-10-08');

--?? date without year, it returns null in mysql
--select week('12-25');
select if(week('12-25')=week(concat(year(sysdate),'-12-25')),'ok','nok');

--select week('8/30');
select if(week('8/30')=week(concat('8/30/',year(sysdate))),'ok','nok');

select week('11/09/1864');



--2. string values of timestamp format
--select week('13:14:55 10/08');
select if(week('13:14:55 10/08')=week(concat('13:14:55 10/08/',year(sysdate))),'ok','nok');

select week('2:22:22 8/12/2010');

select week('09:03:22 PM 1988-08-08');

select week('12/12/2022 10:20:55');



--3. string values of datetime format
--select week('13:14:55.123 10/08');
select if(week('13:14:55.123 10/08')=week(concat('13:14:55.123 10/08/',year(sysdate))),'ok','nok');

select week('2:22:22.333 8/12/2010');

select week('09:03:22.012 PM 1988-08-08');

select week('12/12/1556 10:20:55.567');


