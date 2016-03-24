-- pass different formats of time/timestamp/datetime arguments


--1. pass different formats of time arguments
select hour(time'3:15:17');

select hour(time'8:19:34 AM');

select hour(time'13:11:14 pm');

select hour(time'12:30');

--error
select hour(time'15:30 am');


--2. pass different formats of timestamp arguments
select hour(timestamp'2010-10-08 2:16:10');

select hour(timestamp'2009-1-09 4:30:01 am');

select hour(timestamp'1999-11-30 9:10:10 pm');

select hour(timestamp'13:14:55 10/08');

select hour(timestamp'2:22:22 8/12/2010');

select hour(timestamp'09:03:22 PM 1988-08-08');

select hour(timestamp'12/12/1999 10:20:55');



--3. pass different formats of datetime arguments
select hour(datetime'13:14:55.123 10/08');

select hour(datetime'2:22:22.333 8/12/2010');

select hour(datetime'09:03:22.012 PM 1988-08-08');

select hour(datetime'12/12/1644 10:20:55.789');


