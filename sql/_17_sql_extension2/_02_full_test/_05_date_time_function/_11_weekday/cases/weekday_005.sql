--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select weekday(date'0001-01-01');

select weekday(date'9999-12-31');

select weekday(date'12/31/9999');

select weekday(date'1/1/1');




--2. marginal values: timestamp argument
--select weekday(timestamp'00:00:00 01/01');
select if(weekday(timestamp'00:00:00 01/01')=weekday(timestamp(concat('00:00:00 01/01/',year(sysdate)))),'ok','nok');

select weekday(timestamp'03:14:07 1/19/2038');

select weekday(timestamp'0:0:0 PM 1970-01-01');

select weekday(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
--select weekday(datetime'0:0:0.00 1/1');
select if(weekday(datetime'0:0:0.00 1/1')=weekday(concat('01/01/',year(sysdate))),'ok','nok');
select weekday(datetime'23:59:59.999 12/31/9999');

select weekday(datetime'00:00:00.0000 AM 0001-01-01');

select weekday(datetime'12/31/9999 23:59:59.999');



