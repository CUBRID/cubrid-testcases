--marginal values


--1. marginal values: string type of date format
select month('0001-01-01');

select month('9999-12-31');

select month('12/31//9999');

select month('1/1/1');




--2. marginal values: string type of timestamp format
select month('00:00:00 01/01');

select month('03:14:07 1/19/2038');

select month('0:0:0 PM 1970-01-01');

select month('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
select month('0:0:0.00 1/1');

select month('23:59:59.999 12/31/9999');

select month('00:00:00.0000 AM 0001-01-01');

--[er]
select month('12/31/9999 23:59:59:999');



