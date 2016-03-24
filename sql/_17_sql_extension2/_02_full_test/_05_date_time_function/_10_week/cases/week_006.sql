--pass different formats of date/timestamp/datetime arguments (2 params)


--1. pass different formats of date arguments
select week(date'2010-10-08', 0);

--?? date without year, it returns null in mysql
--select week(date'12-25', 1);
select if(week(date'12-25', 1)=week(date(concat(year(sysdate),'-12-25')),1),'ok','nok');

--select week(date'8/30', 2);
select if(week(date'8/30', 2)=week(date(concat('8/30/',year(sysdate))),2),'ok','nok');

select week(date'11/09/1864', 3);



--2. pass different formats of timestamp arguments
--select week(timestamp'13:14:55 10/08', 4);
select if(week(timestamp'13:14:55 10/08', 4)=week(timestamp(concat('13:14:55 10/08/',year(sysdate))),4),'ok','nok');

select week(timestamp'2:22:22 8/12/2010', 5);

select week(timestamp'09:03:22 PM 1988-08-08', 6);

select week(timestamp'12/12/2022 10:20:55', 7);



--3. pass different formats of datetime arguments
--select week(datetime'13:14:55.123 10/08', 0);
select if(week(datetime'13:14:55.123 10/08',0)=week(concat('10/08/',year(sysdate))),'ok','nok');

select week(datetime'2:22:22.333 8/12/2010', 1);

select week(datetime'09:03:22.012 PM 1988-08-08', 2);

select week(datetime'12/12/1556 10:20:55.567', 3);


