--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select year(date'0001-01-01');

select year(date'9999-12-31');

select year(date'12/31/9999');

select year(date'1/1/1');




--2. marginal values: timestamp argument
--select year(timestamp'00:00:00 01/01');
select if(year(timestamp'00:00:00 01/01')=year(sysdate),'ok','nok');

select year(timestamp'03:14:07 1/19/2038');

select year(timestamp'0:0:0 PM 1970-01-01');

select year(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
--select year(datetime'0:0:0.00 1/1');
select if(year(datetime'0:0:0.00 1/1')=year(sysdate),'ok','nok');

select year(datetime'23:59:59.999 12/31/9999');

select year(datetime'00:00:00.0000 AM 0001-01-01');

select year(datetime'12/31/9999 23:59:59.999');

--[er]
select year(datetime'1:2:3:4 2000-12-12');


