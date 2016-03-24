--pass different formats of string arguments (2 params)


--1. string values of date format
select week('2010-10-08', 0);

--?? date without year, it returns null in mysql
--select week('12-25', 1);
select if(week('12-25', 1)=week(concat(year(sysdate),'-12-25'),1),'ok','nok');

--select week('8/30', 2);
select if(week('8/30',2)=week(concat('8/30/',year(sysdate)),2),'ok','nok');

select week('11/09/1864', 3);



--2. string values of timestamp format
--select week('13:14:55 10/08', 4);
select if(week('13:14:55 10/08',4)=week(concat('13:14:55 10/08/',year(sysdate)),4),'ok','nok');

select week('2:22:22 8/12/2010', 5);

select week('09:03:22 PM 1988-08-08', 6);

select week('12/12/2022 10:20:55', 7);



--3. string values of datetime format
--select week('13:14:55.123 10/08', 0);
select if(week('13:14:55.123 10/08',0)=week(concat('13:14:55.123 10/08/',year(sysdate)),0),'ok','nok');

select week('2:22:22.333 8/12/2010', 1);

select week('09:03:22.012 PM 1988-08-08', 2);

select week('12/12/1556 10:20:55.567', 3);


