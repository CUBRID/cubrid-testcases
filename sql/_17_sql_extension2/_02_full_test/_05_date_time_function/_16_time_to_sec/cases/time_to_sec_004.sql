
--marginal values


--1. marginal values: string type of time format
select time_to_sec('0:00:00');

select time_to_sec('23:59:59 pm');

select time_to_sec('0:0:0 am');

select time_to_sec('23:59');

select time_to_sec('00:00');

--error
select time_to_sec('23:59:59 am');



--2. marginal values: string type of timestamp format
select time_to_sec('00:00:00 01/01');

select time_to_sec('03:14:07 1/19/2038');

select time_to_sec('0:0:0 PM 1970-01-01');

select time_to_sec('1/19/2038 03:14:07 pm');

select time_to_sec('1970-1-1 0:0');

select time_to_sec('2038--01-19 3:14:7');


--3. marginal values: string type of datetime format
select time_to_sec('0:0:0.00 1/1');

select time_to_sec('23:59:59.999 12/31/9999');

select time_to_sec('00:00:00.0000 AM 0001-01-01');

select time_to_sec('12/31/9999 23:59:59.999');


