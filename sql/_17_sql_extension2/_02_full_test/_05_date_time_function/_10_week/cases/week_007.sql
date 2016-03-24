--marginal values


--1. marginal values: string type of date format
select week('0001-01-01');

select week('9999-12-31');

select week('12/31/9999');

select week('1/1/1');




--2. marginal values: string type of timestamp format
--select week('00:00:00 01/01');
select if(week('00:00:00 01/01')=week(concat('00:00:00 01/01/',year(sysdate))),'ok','nok');

select week('03:14:07 1/19/2038');

select week('0:0:0 PM 1970-01-01');

select week('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
--select week('0:0:0.00 1/1');
select if(week('0:0:0.00 1/1')=week(concat('0:0:0.00 1/1/',year(sysdate))),'ok','nok');

select week('23:59:59.999 12/31/9999');

select week('00:00:00.0000 AM 0001-01-01');

select week('12/31/9999 23:59:59.999');



