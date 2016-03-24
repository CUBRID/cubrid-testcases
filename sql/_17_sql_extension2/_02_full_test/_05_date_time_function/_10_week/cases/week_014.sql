--pass out-of-range data of date/timestamp/datetime type to the 1st parameter
--pass out-of-range int data to the 2nd parameter



--1. [error] out-of-range argument of date type
select week(date'13/11/1989', 0);

select week(date'05/33/1901', 1);

select week(date'2/20/10000', 2);

select week(date'0-1-1', 3);

select week(date'1999-04-31', 4);

select week(date'03-02-31', 5);

select week(date'0000-00-00', 0);
select week(date'0000-00-00', 1);
select week(date'0000-00-00', 2);
select week(date'0000-00-00', 3);
select week(date'0000-00-00', 4);
select week(date'0000-00-00', 5);
select week(date'0000-00-00', 6);
select week(date'0000-00-00', 7);



--2. [error] out-of-range argument of timestamp type
select week(timestamp'23:00:00 13/01', 6);

select week(timestamp'04:14:07 1/19/2038', 7);

select week(timestamp'03:15:07 1/19/2038', 0);

select week(timestamp'03:14:08 1/19/2038', 1);

select week(timestamp'03:14:07 2/19/2038', 2);

select week(timestamp'03:14:07 1/20/2038', 3);

select week(timestamp'03:14:07 1/19/2039', 4);

--??
select week(timestamp'03:14:07 PM 1/19/2038', 5);

select week(timestamp'0:0:0 PM 1969-01-01', 6);

select week(timestamp'11:03:22 PM 1864-01-23', 7);

select week(timestamp'2300-12-12 22:02:33', 0);

select week(timestamp'2020-23-11 03:14:66 pm', 1);

select week(timestamp'1970-10-101 0:0', 2);

select week(timestamp'1999/12/11 3:14:7 am', 3);

select week(timestamp'2010-4-31 3:14:7 am', 8);



--3. [error] out-of-range argument of datetime type
select week(datetime'2010-10 10:10:100.00 am', -1);

select week(datetime'24:59:59.999 12/31/9999', 4);

select week(datetime'23:60:59.999 12/31/9999', 5);

select week(datetime'23:59:60.999 12/31/9999', 6);

select week(datetime'23:59:59.1000 12/31/9999', 7);

select week(datetime'23:59:59.999 13/31/9999', 8);

select week(datetime'23:59:59.999 12/32/9999', 9);

select week(datetime'23:59:59.999 12/31/10000', 10);

select week(datetime'20:33:61.111 1990-10-19 ', 0);

select week(datetime'2/31/2022 10:20:30.400', 2);

select week(datetime'12/31/9999 23:59:59.999', 4);

select week(datetime'0-12-12 23:59:59.999', 6);



--4. [error] out-of-range int argument to 2nd parameter 
select week(datetime'1900-12-12 23:59:59.999', 8);

select week(date'3/12/2010', -100);

select week(timestamp'12:30:20 2009-10-10', 1000);
