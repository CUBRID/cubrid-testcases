--pass different formats of date/timestamp/datetime arguments


--1. pass different formats of date arguments
select year(date'2010-10-08');

--select year(date'12-25');
select if(year(date'12-25')=year(sysdate),'ok','nok');

--select year(date'8/30');
select if(year(date'8/30')=year(sysdate),'ok','nok');

select year(date'11/09/1864');



--2. pass different formats of timestamp arguments
--select year(timestamp'13:14:55 10/08');
select if(year(timestamp'13:14:55 10/08')=year(sysdate),'ok','nok');

select year(timestamp'2:22:22 8/12/2010');

select year(timestamp'09:03:22 PM 1988-08-08');

select year(timestamp'12/12/2033 10:20:55');



--3. pass different formats of datetime arguments
--select year(datetime'13:14:55.123 10/08');
select if(year(datetime'13:14:55.123 10/08')=year(sysdate),'ok','nok');

select year(datetime'2:22:22.333 8/12/2010');

select year(datetime'09:03:22.012 PM 1988-08-08');

select year(datetime'12/12/1556 10:20:55.567');


