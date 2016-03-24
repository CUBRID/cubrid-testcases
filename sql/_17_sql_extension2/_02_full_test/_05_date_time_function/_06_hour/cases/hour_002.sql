--pass different formats of string arguments


--1. string values of time format
select hour('3:15:17');

select hour('8:19:34 AM');

select hour('13:11:14 pm');

select hour('12:30');

--error
select hour('15:30 am');



--2. string values of timestamp format
select hour('2010-10-08 2:16:10');

select hour('2009-1-09 4:30:01 am');

select hour('1999-11-30 9:10:10 pm');

select hour('13:14:55 10/08');

select hour('2:22:22 8/12/2010');

select hour('09:03:22 PM 1988-08-08');

select hour('12/12/1999 10:20:55');


--3. string values of datetime format
select hour('13:14:55.123 10/08');

select hour('2:22:22.333 8/12/2010');

select hour('09:03:22.012 PM 1988-08-08');

select hour('12/12/1644 10:20:55.789');


