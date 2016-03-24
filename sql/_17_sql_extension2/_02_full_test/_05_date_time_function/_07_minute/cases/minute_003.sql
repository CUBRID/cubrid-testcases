-- pass different formats of time/timestamp/datetime arguments


--1. pass different formats of time arguments
select minute(time'3:15:17');

select minute(time'8:19:34 AM');

select minute(time'13:11:14 pm');

select minute(time'12:30');

--error
select minute(time'15:30 am');


--2. pass different formats of timestamp arguments
select minute(timestamp'2010-10-08 2:16:10');

select minute(timestamp'2009-1-09 4:30:01 am');

select minute(timestamp'1999-11-30 9:10:10 pm');

select minute(timestamp'13:14:55 10/08');

select minute(timestamp'2:22:22 8/12/2010');

select minute(timestamp'09:03:22 PM 1988-08-08');

select minute(timestamp'12/12/1999 10:20:55');



--3. pass different formats of datetime arguments
select minute(datetime'13:14:55.123 10/08');

select minute(datetime'2:22:22.333 8/12/2010');

select minute(datetime'09:03:22.012 PM 1988-08-08');

select minute(datetime'12/12/1644 10:20:55.789');


