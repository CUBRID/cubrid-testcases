--marginal values of time/timestamp/datetime type


--1. marginal values: time argument
select hour(time'0:00:00');

select hour(time'23:59:59 pm');

select hour(time'0:0:0 am');

select hour(time'23:59');

select hour(time'00:00');

--error
select hour(time'23:59:59 am');



--2. marginal values: timestamp argument
select hour(timestamp'00:00:00 01/01');

select hour(timestamp'03:14:07 1/19/2038');

select hour(timestamp'0:0:0 PM 1970-01-01');

select hour(timestamp'1/19/2038 03:14:07 pm');

select hour(timestamp'1970-1-1 0:0');

select hour(timestamp'2038--01-19 3:14:7');


--3. marginal values: datetime argument
select hour(datetime'0:0:0.00 1/1');

select hour(datetime'23:59:59.999 12/31/9999');

select hour(datetime'00:00:00.0000 AM 0001-01-01');

select hour(datetime'12/31/9999 23:59:59.999');


