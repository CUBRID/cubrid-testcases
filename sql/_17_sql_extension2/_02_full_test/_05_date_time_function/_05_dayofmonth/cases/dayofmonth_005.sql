--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select dayofmonth(date'0001-01-01');

select dayofmonth(date'9999-12-31');

select dayofmonth(date'12/31/9999');

select dayofmonth(date'1/1/1');




--2. marginal values: timestamp argument
select dayofmonth(timestamp'00:00:00 01/01');

select dayofmonth(timestamp'03:14:07 1/19/2038');

select dayofmonth(timestamp'0:0:0 PM 1970-01-01');

select dayofmonth(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
select dayofmonth(datetime'0:0:0.00 1/1');

select dayofmonth(datetime'23:59:59.999 12/31/9999');

select dayofmonth(datetime'00:00:00.0000 AM 0001-01-01');

select dayofmonth(datetime'12/31/9999 23:59:59.999');



