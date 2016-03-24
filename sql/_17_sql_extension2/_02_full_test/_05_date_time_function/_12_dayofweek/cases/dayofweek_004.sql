--marginal values


--1. marginal values: string type of date format
select dayofweek('0001-01-01');

select dayofweek('9999-12-31');

select dayofweek('12/31/9999');

select dayofweek('1/1/1');




--2. marginal values: string type of timestamp format
--select dayofweek('00:00:00 01/01');
select if(dayofweek('00:00:00 01/01')=dayofweek(concat('00:00:00 01/01/',year(sysdate))),'ok','nok');

select dayofweek('03:14:07 1/19/2038');

select dayofweek('0:0:0 PM 1970-01-01');

select dayofweek('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
--select dayofweek('0:0:0.00 1/1');
select if(dayofweek('00:00:00 1/1')=dayofweek(concat('00:00:00 1/1/',year(sysdate))),'ok','nok');

select dayofweek('23:59:59.999 12/31/9999');

select dayofweek('00:00:00.0000 AM 0001-01-01');

select dayofweek('12/31/9999 23:59:59.999');



