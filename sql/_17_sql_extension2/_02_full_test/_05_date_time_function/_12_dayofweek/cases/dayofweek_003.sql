--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select dayofweek(date'2010-10-08');

--select dayofweek(date'12-25');
select if(dayofweek(date'12-25')=dayofweek(date(concat(year(sysdate),'-12-25'))),'ok','nok');

--select dayofweek(date'8/30');
select if(dayofweek(date'8/30')=dayofweek(date(concat('8/30/',year(sysdate)))),'ok','nok');

select dayofweek(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select dayofweek(timestamp'13:14:55 10/08');
select if(dayofweek(timestamp'13:14:55 10/08')=dayofweek(timestamp(concat('13:14:55 10/08/',year(sysdate)))),'ok','nok');

select dayofweek(timestamp'2:22:22 8/12/2010');

select dayofweek(timestamp'09:03:22 PM 1988-08-08');

select dayofweek(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select dayofweek(datetime'13:14:55.123 10/08');
select if(dayofweek(datetime'13:14:55.123 10/08')=dayofweek(concat('10/08/',year(sysdate))),'ok','nok');

select dayofweek(datetime'2:22:22.333 8/12/2010');

select dayofweek(datetime'09:03:22.012 PM 1988-08-08');

select dayofweek(datetime'12/12/1556 10:20:55.567');


