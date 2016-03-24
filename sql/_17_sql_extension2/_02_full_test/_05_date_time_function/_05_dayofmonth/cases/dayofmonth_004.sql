--marginal values


--1. marginal values: string type of date format
select dayofmonth('0001-01-01');

select dayofmonth('9999-12-31');

select dayofmonth('12/31/9999');

select dayofmonth('1/1/1');




--2. marginal values: string type of timestamp format
select dayofmonth('00:00:00 01/01');

select dayofmonth('03:14:07 1/19/2038');

select dayofmonth('0:0:0 PM 1970-01-01');

select dayofmonth('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
select dayofmonth('0:0:0.00 1/1');

select dayofmonth('23:59:59.999 12/31/9999');

select dayofmonth('00:00:00.0000 AM 0001-01-01');

--[er]
select dayofmonth('12/31/9999 23:59:59:999');



