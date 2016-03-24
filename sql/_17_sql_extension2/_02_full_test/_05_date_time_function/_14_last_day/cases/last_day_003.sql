--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select last_day(date'2010-10-08');

--select last_day(date'12-25');
select if(last_day(date(concat(year(sysdate),'-12-25')))=last_day(date'12-25'),'ok','nok');

--select last_day(date'8/30');
select if(last_day(date(concat('8/30/',year(sysdate))))=last_day(date'8/30'),'ok','nok');

select last_day(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select last_day(timestamp'13:14:55 10/08');
select if(last_day(timestamp(concat('13:14:55 10/08/',year(sysdate))))=last_day(timestamp'13:14:55 10/08'),'ok','nok');

select last_day(timestamp'2:22:22 8/12/2010');

select last_day(timestamp'09:03:22 PM 1988-08-08');

select last_day(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select last_day(datetime'13:14:55.123 10/08');
select if(last_day(datetime'13:14:55.123 10/08')=last_day(concat('10/08/',year(sysdate))),'ok','nok');

select last_day(datetime'2:22:22.333 8/12/2010');

select last_day(datetime'09:03:22.012 PM 1988-08-08');

select last_day(datetime'12/12/1556 10:20:55.567');


