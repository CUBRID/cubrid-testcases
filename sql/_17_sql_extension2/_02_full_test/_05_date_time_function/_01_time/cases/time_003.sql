-- pass different formats of time/timestamp/datetime arguments


--1. pass different formats of time arguments
select time(time'3:15:17');

select time(time'8:19:34 AM');

select time(time'13:11:14 pm');

select time(time'12:30');

--error
select time(time'15:30 am');


--2. pass different formats of timestamp arguments
select time(timestamp'2010-10-08 2:16:10');

select time(timestamp'2009-1-09 4:30:01 am');

select time(timestamp'1999-11-30 9:10:10 pm');

select time(timestamp'13:14:55 10/08');

select time(timestamp'2:22:22 8/12/2010');

select time(timestamp'09:03:22 PM 1988-08-08');

select time(timestamp'12/12/1999 10:20:55');

--error
select time(timestamp'12/12/1999 18:20:55 AM');



--3. pass different formats of datetime arguments
select time(datetime'13:14:55.123 10/08');

select time(datetime'2:22:22.333 8/12/2010');

select time(datetime'09:03:22.012 PM 1988-08-08');

select time(datetime'12/12/1644 10:20:55.789');

--error
select time(datetime'12/12/1644 21:20:55.789 am');

