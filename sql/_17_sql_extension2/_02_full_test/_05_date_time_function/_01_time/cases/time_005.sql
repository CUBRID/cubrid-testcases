--marginal values of time/timestamp/datetime type


--1. marginal values: time argument
select time(time'0:00:00');

select time(time'23:59:59 pm');

select time(time'0:0:0 am');

select time(time'23:59');

select time(time'00:00');

--error
select time(time'23:59:59 am');



--2. marginal values: timestamp argument
select time(timestamp'00:00:00 01/01');

select time(timestamp'03:14:07 1/19/2038');

select time(timestamp'0:0:0 PM 1970-01-01');

--[er]
select time(timestamp'1/19/2038 03:14:07 pm');

--[er]
select time(timestamp'1970-1-1 0:0');

--[er]
select time(timestamp'2038--01-19 3:14:7');


--3. marginal values: datetime argument
--[er]
select time(datetime'0:0:0:00 1/1');

--[er]
select time(datetime'23:59:59:999 12/31/9999');

--[er]
select time(datetime'00:00:00:0000 AM 0001-01-01');

--[er]
select time(datetime'12/31/9999 23:59:59:999');



select time(datetime'0:0:0.00 1/1');

select time(datetime'23:59:59.999 12/31/9999');

select time(datetime'00:00:00.0000 AM 0001-01-01');

select time(datetime'12/31/9999 23:59:59.999');
