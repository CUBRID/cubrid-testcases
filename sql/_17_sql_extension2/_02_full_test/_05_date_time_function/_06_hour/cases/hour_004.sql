
--marginal values


--1. marginal values: string type of time format
select hour('0:00:00');

select hour('23:59:59 pm');

select hour('0:0:0 am');

select hour('23:59');

select hour('00:00');

--error
select hour('23:59:59 am');



--2. marginal values: string type of timestamp format
select hour('00:00:00 01/01');

select hour('03:14:07 1/19/2038');

select hour('0:0:0 PM 1970-01-01');

select hour('1/19/2038 03:14:07 pm');

select hour('1970-1-1 0:0');

select hour('2038--01-19 3:14:7');


--3. marginal values: string type of datetime format
select hour('0:0:0.00 1/1');

select hour('23:59:59.999 12/31/9999');

select hour('00:00:00.0000 AM 0001-01-01');

select hour('12/31/9999 23:59:59.999');

--[er]
select hour('0:0:0:00 1/1');

