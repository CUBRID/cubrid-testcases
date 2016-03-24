--pass different formats of string arguments


--1. string values of date format
select to_days('2010-10-08');

--select to_days('12-25');
select if(to_days(concat(year(sysdate),'-12-25'))=to_days('12-25'),'ok','nok');

--select to_days('8/30');
select if(to_days(concat('8/30/',year(sysdate)))=to_days('8/30'),'ok','nok');

select to_days('11/09/1864');



--2. string values of timestamp format
--select to_days('13:14:55 10/08');
select if(to_days(concat('13:14:55 10/08/',year(sysdate)))=to_days('13:14:55 10/08'),'ok','nok');

select to_days('2:22:22 8/12/2010');

select to_days('09:03:22 PM 1988-08-08');

select to_days('12/12/2022 10:20:55');



--3. string values of datetime format
--select to_days('13:14:55.123 10/08');
select if(to_days(concat('13:14:55.123 10/08/',year(sysdate)))=to_days('13:14:55.123 10/08'),'ok','nok');

select to_days('2:22:22.333 8/12/2010');

select to_days('09:03:22.012 PM 1988-08-08');

select to_days('12/12/1556 10:20:55.567');


