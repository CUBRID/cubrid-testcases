--marginal values


--1. marginal values: string type of date format
select dayofyear('0001-01-01');

select dayofyear('9999-12-31');

select dayofyear('12/31/9999');

select dayofyear('1/1/1');




--2. marginal values: string type of timestamp format
select dayofyear('00:00:00 01/01');

select dayofyear('03:14:07 1/19/2038');

select dayofyear('0:0:0 PM 1970-01-01');

select dayofyear('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
select dayofyear('0:0:0.00 1/1');

select dayofyear('23:59:59.999 12/31/9999');

select dayofyear('00:00:00.0000 AM 0001-01-01');

select dayofyear('12/31/9999 23:59:59.999');



