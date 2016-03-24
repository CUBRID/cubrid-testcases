--marginal values


--1. marginal values: string type of date format
select weekday('0001-01-01');

select weekday('9999-12-31');

select weekday('12/31/9999');

select weekday('1/1/1');




--2. marginal values: string type of timestamp format
--select weekday('00:00:00 01/01');
select if(weekday('00:00:00 01/01')=weekday(concat('00:00:00 01/01/',year(sysdate))),'ok','nok');

select weekday('03:14:07 1/19/2038');

select weekday('0:0:0 PM 1970-01-01');

select weekday('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
--select weekday('0:0:0.00 1/1');
select if(weekday('0:0:0.00 1/1')=weekday(concat('0:0:0.00 1/1/',year(sysdate))),'ok','nok');

select weekday('23:59:59.999 12/31/9999');

select weekday('00:00:00.0000 AM 0001-01-01');

select weekday('12/31/9999 23:59:59.999');



