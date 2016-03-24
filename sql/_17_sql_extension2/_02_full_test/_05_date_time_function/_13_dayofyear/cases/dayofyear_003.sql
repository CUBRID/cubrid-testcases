--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select dayofyear(date'2010-10-08');

--select dayofyear(date'12-25');
select if(dayofyear(date'12-25')=dayofyear(date(concat(year(sysdate),'-12-25'))),'ok','nok');

--select dayofyear(date'8/30');
select if(dayofyear(date'8/30')=dayofyear(date(concat('8/30/',year(sysdate)))),'ok','nok');

select dayofyear(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select dayofyear(timestamp'13:14:55 10/08');
select if(dayofyear(timestamp'13:14:55 10/08')=dayofyear(timestamp(concat('13:14:55 10/08/',year(sysdate)))),'ok','nok');

select dayofyear(timestamp'2:22:22 8/12/2010');

select dayofyear(timestamp'09:03:22 PM 1988-08-08');

select dayofyear(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select dayofyear(datetime'13:14:55.123 10/08');
select if(dayofyear(datetime'13:14:55.123 10/08')=dayofyear(concat('10/08/',year(sysdate))), 'ok','nok');

select dayofyear(datetime'2:22:22.333 8/12/2010');

select dayofyear(datetime'09:03:22.012 PM 1988-08-08');

select dayofyear(datetime'12/12/1556 10:20:55.567');


