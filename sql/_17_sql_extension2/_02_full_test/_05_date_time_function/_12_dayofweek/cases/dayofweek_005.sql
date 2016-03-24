--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select dayofweek(date'0001-01-01');

select dayofweek(date'9999-12-31');

select dayofweek(date'12/31/9999');

select dayofweek(date'1/1/1');




--2. marginal values: timestamp argument
--select dayofweek(timestamp'00:00:00 01/01');
select if(dayofweek(timestamp'00:00:00 01/01')=dayofweek(timestamp(concat('00:00:00 01/01/',year(sysdate)))),'ok','nok');

select dayofweek(timestamp'03:14:07 1/19/2038');

select dayofweek(timestamp'0:0:0 PM 1970-01-01');

select dayofweek(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
--select dayofweek(datetime'0:0:0.00 1/1');
select if(dayofweek(datetime'0:0:0.00 1/1')=dayofweek(concat('01/01/',year(sysdate))),'ok','nok');

select dayofweek(datetime'23:59:59.999 12/31/9999');

select dayofweek(datetime'00:00:00.0000 AM 0001-01-01');

select dayofweek(datetime'12/31/9999 23:59:59.999');



