--marginal values


--1. marginal values: string type of date format
select quarter('0001-01-01');

select quarter('9999-12-31');

select quarter('12/31/9999');

select quarter('1/1/1');




--2. marginal values: string type of timestamp format
select quarter('00:00:00 01/01');

select quarter('03:14:07 1/19/2038');

select quarter('0:0:0 PM 1970-01-01');

select quarter('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
select quarter('0:0:0.00 1/1');

select quarter('23:59:59.999 12/31/9999');

select quarter('00:00:00.0000 AM 0001-01-01');

select quarter('12/31/9999 23:59:59.999');

--[er]
select quarter('23:59:59:999 12/31/9999');


