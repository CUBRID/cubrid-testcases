-- pass different formats of time/timestamp/datetime arguments


--1. pass different formats of time arguments
select second(time'3:15:17');

select second(time'8:19:34 AM');

select second(time'13:11:14 pm');

select second(time'12:30');

--error
select second(time'15:30:45 am');


--2. pass different formats of timestamp arguments
select second(timestamp'2010-10-08 2:16:10');

select second(timestamp'2009-1-09 4:30:01 am');

select second(timestamp'1999-11-30 9:10:10 pm');

select second(timestamp'13:14:55 10/08');

select second(timestamp'2:22:22 8/12/2010');

select second(timestamp'09:03:22 PM 1988-08-08');

select second(timestamp'12/12/1999 10:20:55');



--3. pass different formats of datetime arguments
select second(datetime'13:14:55.123 10/08');

select second(datetime'2:22:22.333 8/12/2010');

select second(datetime'09:03:22.012 PM 1988-08-08');

select second(datetime'12/12/1644 10:20:55.789');


