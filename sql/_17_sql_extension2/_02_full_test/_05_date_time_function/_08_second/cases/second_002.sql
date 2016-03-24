--pass different formats of string arguments


--1. string values of time format
select second('3:15:17');

select second('8:19:34 AM');

select second('13:11:14 pm');

select second('12:30');

select second(35);

select second(2011);

select second(20455);

--[er]
select second(1999);

--error
select second('15:30:45 am');



--2. string values of timestamp format
select second('2010-10-08 2:16:10');

select second('2009-1-09 4:30:01 am');

select second('1999-11-30 9:10:10 pm');

select second('13:14:55 10/08');

select second('2:22:22 8/12/2010');

select second('09:03:22 PM 1988-08-08');

select second('12/12/1999 10:20:55');


--3. string values of datetime format
select second('13:14:55.123 10/08');

select second('2:22:22.333 8/12/2010');

select second('09:03:22.012 PM 1988-08-08');

select second('12/12/1644 10:20:55.789');


