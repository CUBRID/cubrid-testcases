--pass different formats of string arguments


--1. string values of time format
select time('3:15:17');

select time('8:19:34 AM');

select time('13:11:14 pm');

select time('12:30');

select time('12:12:12.3456');

--error
select time('15:30 am');



--2. string values of timestamp format
select time('2010-10-08 2:16:10');

select time('2009-1-09 4:30:01 am');

select time('1999-11-30 9:10:10 pm');

select time('13:14:55 10/08');

select time('2:22:22 8/12/2010');

select time('09:03:22 PM 1988-08-08');

select time('12/12/1999 10:20:55');

--error
select time('13:14:55 AM 10/08');



--3. string values of datetime format
select time('13:14:55.123 10/08');

select time('2:22:22.333 8/12/2010');

select time('09:03:22.012 PM 1988-08-08');

select time('12/12/1644 10:20:55.789');

--error
select time('19:03:22.012 AM 1988-08-08');
