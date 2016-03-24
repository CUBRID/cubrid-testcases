--marginal values of time/timestamp/datetime type


--1. marginal values: time argument
select minute(time'0:00:00');

select minute(time'23:59:59 pm');

select minute(time'0:0:0 am');

select minute(time'23:59');

select minute(time'00:00');

--error
select minute('23:59:59 am');



--2. marginal values: timestamp argument
select minute(timestamp'00:00:00 01/01');

select minute(timestamp'03:14:07 1/19/2038');

select minute(timestamp'0:0:0 PM 1970-01-01');

select minute(timestamp'1/19/2038 03:14:07 pm');

select minute(timestamp'1970-1-1 0:0');

select minute(timestamp'2038--01-19 3:14:7');


--3. marginal values: datetime argument
select minute(datetime'0:0:0.00 1/1');

select minute(datetime'23:59:59.999 12/31/9999');

select minute(datetime'00:00:00.0000 AM 0001-01-01');

select minute(datetime'12/31/9999 23:59:59.999');


