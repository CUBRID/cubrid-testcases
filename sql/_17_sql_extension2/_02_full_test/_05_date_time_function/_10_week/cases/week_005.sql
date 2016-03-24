--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select week(date'2010-10-08');

--select week(date'12-25');
select if(week(date'12-25')=week(date(concat(year(sysdate),'-12-25'))),'ok','nok');

--select week(date'8/30');
select if(week(date'8/30')=week(date(concat('8/30/',year(sysdate)))),'ok','nok');

select week(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select week(timestamp'13:14:55 10/08');
select if(week(timestamp'13:14:55 10/08')=week(timestamp(concat('13:14:55 10/08/',year(sysdate)))),'ok','nok');

select week(timestamp'2:22:22 8/12/2010');

select week(timestamp'09:03:22 PM 1988-08-08');

select week(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select week(datetime'13:14:55.123 10/08');
select if(week(datetime'13:14:55.123 10/08')=week(concat('10/08/',year(sysdate))),'ok','nok');

select week(datetime'2:22:22.333 8/12/2010');

select week(datetime'09:03:22.012 PM 1988-08-08');

select week(datetime'12/12/1556 10:20:55.567');


