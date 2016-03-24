--marginal values of time/timestamp/datetime type


--1. marginal values: time argument
select second(time'0:00:00');

select second(time'23:59:59 pm');

select second(time'0:0:0 am');

select second(time'23:59');

select second(time'00:00');

--error
select second(time'23:59:59 am');



--2. marginal values: timestamp argument
select second(timestamp'00:00:00 01/01');

select second(timestamp'03:14:07 1/19/2038');

select second(timestamp'0:0:0 PM 1970-01-01');

select second(timestamp'1/19/2038 03:14:07 pm');

select second(timestamp'1970-1-1 0:0');

select second(timestamp'2038--01-19 3:14:7');


--3. marginal values: datetime argument
select second(datetime'0:0:0.00 1/1');

select second(datetime'23:59:59.999 12/31/9999');

select second(datetime'00:00:00.0000 AM 0001-01-01');

select second(datetime'12/31/9999 23:59:59.999');


