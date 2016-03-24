--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select quarter(date'0001-01-01');

select quarter(date'9999-12-31');

select quarter(date'12/31/9999');

select quarter(date'1/1/1');




--2. marginal values: timestamp argument
select quarter(timestamp'00:00:00 01/01');

select quarter(timestamp'03:14:07 1/19/2038');

select quarter(timestamp'0:0:0 PM 1970-01-01');

select quarter(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
select quarter(datetime'0:0:0.00 1/1');

select quarter(datetime'23:59:59.999 12/31/9999');

select quarter(datetime'00:00:00.0000 AM 0001-01-01');

select quarter(datetime'12/31/9999 23:59:59.999');

--[er]
select quarter(datetime'0:0:0:00 1/1');


