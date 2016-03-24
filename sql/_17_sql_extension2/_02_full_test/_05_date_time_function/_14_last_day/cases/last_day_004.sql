--marginal values


--1. marginal values: string type of date format
select last_day('0001-01-01');

select last_day('9999-12-31');

select last_day('12/31/9999');

select last_day('1/1/1');




--2. marginal values: string type of timestamp format
--select last_day('00:00:00 01/01');
select if(last_day(concat('00:00:00 01/01/',year(sysdate)))=last_day('00:00:00 01/01'),'ok','nok');

select last_day('03:14:07 1/19/2038');

select last_day('0:0:0 PM 1970-01-01');

select last_day('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
--select last_day('0:0:0.00 1/1');
select if(last_day(concat('0:0:0.00 1/1/',year(sysdate)))=last_day('0:0:0.00 1/1'),'ok','nok');

select last_day('23:59:59.999 12/31/9999');

select last_day('00:00:00.0000 AM 0001-01-01');

select last_day('12/31/9999 23:59:59.999');



