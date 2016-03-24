--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select to_days(date'0001-01-01');

select to_days(date'9999-12-31');

select to_days(date'12/31/9999');

select to_days(date'1/1/1');




--2. marginal values: timestamp argument
--select to_days(timestamp'00:00:00 01/01');
select if(to_days(timestamp(concat('00:00:00 01/01/',year(sysdate))))=to_days(timestamp'00:00:00 01/01'), 'ok','nok');

select to_days(timestamp'03:14:07 1/19/2038');

select to_days(timestamp'0:0:0 PM 1970-01-01');

select to_days(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
--select to_days(datetime'0:0:0.00 1/1');
select if(to_days(datetime'0:0:0.00 1/1')=to_days(concat('01/01/',year(sysdate))), 'ok','nok');

select to_days(datetime'23:59:59.999 12/31/9999');

select to_days(datetime'00:00:00.0000 AM 0001-01-01');

select to_days(datetime'12/31/9999 23:59:59.999');



