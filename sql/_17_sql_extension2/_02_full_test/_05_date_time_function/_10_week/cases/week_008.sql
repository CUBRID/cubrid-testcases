--marginal values of date/timestamp/datetime type


--1. marginal values: date argument
select week(date'0001-01-01');

select week(date'9999-12-31');

select week(date'12/31/9999');

select week(date'1/1/1');




--2. marginal values: timestamp argument
--select week(timestamp'00:00:00 01/01');
select if(week(timestamp'00:00:00 01/01')=week(timestamp(concat('00:00:00 01/01/',year(sysdate)))),'ok','nok');

select week(timestamp'03:14:07 1/19/2038');

select week(timestamp'0:0:0 PM 1970-01-01');

select week(timestamp'1/19/2038 03:14:07 pm');



--3. marginal values: datetime argument
--select week(datetime'0:0:0.00 1/1');
select if(week(datetime'0:0:0.00 1/1')=week(concat('01/01/',year(sysdate))),'ok','nok');

select week(datetime'23:59:59.999 12/31/9999');

select week(datetime'00:00:00.0000 AM 0001-01-01');

select week(datetime'12/31/9999 23:59:59.999');



