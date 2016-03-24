--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select to_days(date'2010-10-08');

--select to_days(date'12-25');
select if(to_days(date(concat(year(sysdate),'-12-25')))=to_days(date'12-25'),'ok','nok');

--select to_days(date'8/30');
select if(to_days(date(concat('8/30/',year(sysdate))))=to_days(date'8/30'),'ok','nok');

select to_days(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select to_days(timestamp'13:14:55 10/08');
select if(to_days(timestamp(concat('13:14:55 10/08/',year(sysdate))))=to_days(timestamp'13:14:55 10/08'),'ok','nok');

select to_days(timestamp'2:22:22 8/12/2010');

select to_days(timestamp'09:03:22 PM 1988-08-08');

select to_days(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select to_days(datetime'13:14:55.123 10/08');
select if(to_days(datetime'13:14:55.123 10/08')=to_days(concat('10/08/',year(sysdate))),'ok','nok');

select to_days(datetime'2:22:22.333 8/12/2010');

select to_days(datetime'09:03:22.012 PM 1988-08-08');

select to_days(datetime'12/12/1556 10:20:55.567');


