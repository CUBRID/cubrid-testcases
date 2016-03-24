--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select dayofyear(date'0001-01-01');

select dayofyear(date'9999-12-31');

select dayofyear(date'12/31/9999');

select dayofyear(date'1/1/1');




--2. marginal values: timestamp argument
select dayofyear(timestamp'00:00:00 01/01');

select dayofyear(timestamp'03:14:07 1/19/2038');

select dayofyear(timestamp'0:0:0 PM 1970-01-01');

select dayofyear(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
select dayofyear(datetime'0:0:0.00 1/1');

select dayofyear(datetime'23:59:59.999 12/31/9999');

select dayofyear(datetime'00:00:00.0000 AM 0001-01-01');

select dayofyear(datetime'12/31/9999 23:59:59.999');



