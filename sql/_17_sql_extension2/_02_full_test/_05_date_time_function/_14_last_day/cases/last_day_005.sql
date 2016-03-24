--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select last_day(date'0001-01-01');

select last_day(date'9999-12-31');

select last_day(date'12/31/9999');

select last_day(date'1/1/1');




--2. marginal values: timestamp argument
--select last_day(timestamp'00:00:00 01/01');
select if(last_day(timestamp(concat('00:00:00 01/01/',year(sysdate))))=last_day('00:00:00 01/01'),'ok','nok');

select last_day(timestamp'03:14:07 1/19/2038');

select last_day(timestamp'0:0:0 PM 1970-01-01');

select last_day(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
--select last_day(datetime'0:0:0.00 1/1');
select if(last_day(datetime'0:0:0.00 1/1')=last_day(concat('01/01/',year(sysdate))),'ok','nok');

select last_day(datetime'23:59:59.999 12/31/9999');

select last_day(datetime'00:00:00.0000 AM 0001-01-01');

select last_day(datetime'12/31/9999 23:59:59.999');



