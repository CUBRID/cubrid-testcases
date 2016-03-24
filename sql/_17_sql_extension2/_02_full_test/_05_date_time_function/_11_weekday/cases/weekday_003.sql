--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select weekday(date'2010-10-08');

--select weekday(date'12-25');
select if(weekday(date'12-25')=weekday(date(concat(year(sysdate),'-12-25'))),'ok','nok');

--select weekday(date'8/30');
select if(weekday(date'8/30')=weekday(date(concat('8/30/',year(sysdate)))),'ok','nok');

select weekday(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select weekday(timestamp'13:14:55 10/08');
select if(weekday(timestamp'13:14:55 10/08')=weekday(timestamp(concat('13:14:55 10/08/',year(sysdate)))),'ok','nok');

select weekday(timestamp'2:22:22 8/12/2010');

select weekday(timestamp'09:03:22 PM 1988-08-08');

select weekday(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select weekday(datetime'13:14:55.123 10/08');
select if(weekday(datetime'13:14:55.123 10/08')=weekday(concat('10/08/',year(sysdate))),'ok','nok');

select weekday(datetime'2:22:22.333 8/12/2010');

select weekday(datetime'09:03:22.012 PM 1988-08-08');

select weekday(datetime'12/12/1556 10:20:55.567');


