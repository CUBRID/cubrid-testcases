
--marginal values


--1. marginal values: string type of time format
select time('0:00:00');

select time('23:59:59 pm');

select time('0:0:0 am');

select time('23:59');

select time('00:00');

--error
select time('23:59:59 am');



--2. marginal values: string type of timestamp format
select time('00:00:00 01/01');

select time('03:14:07 1/19/2038');

select time('0:0:0 PM 1970-01-01');

--error, out of range
select time('1/19/2038 03:14:07 pm');

--error, out of range
select time('1970-1-1 0:0');

--error, wrong format
select time('2038--01-19 3:14:7');


--3. marginal values: string type of datetime format
--[er], wrong format
select time('0:0:0:00 1/1');

--[er], wrong format
select time('23:59:59:999 12/31/9999');

--[er], wrong format
select time('00:00:00:0000 AM 0001-01-01');

--[er], wrong format
select time('12/31/9999 23:59:59:999');


select time('0:0:0.00 1/1');

select time('23:59:59.999 12/31/9999');

select time('00:00:00.0000 AM 0001-01-01');

select time('12/31/9999 23:59:59.999');
