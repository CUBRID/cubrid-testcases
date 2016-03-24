--marginal values


--1. marginal values: string type of date format
select to_days('0001-01-01');

select to_days('9999-12-31');

select to_days('12/31/9999');

select to_days('1/1/1');




--2. marginal values: string type of timestamp format
--select to_days('00:00:00 01/01');
select if(to_days(concat('00:00:00 01/01/',year(sysdate)))=to_days('00:00:00 01/01'), 'ok','nok');

select to_days('03:14:07 1/19/2038');

select to_days('0:0:0 PM 1970-01-01');

select to_days('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
--select to_days('0:0:0.00 1/1');
select if(to_days(concat('0:0:0.00 1/1/',year(sysdate)))=to_days('0:0:0.00 1/1'), 'ok','nok');

select to_days('23:59:59.999 12/31/9999');

select to_days('00:00:00.0000 AM 0001-01-01');

select to_days('12/31/9999 23:59:59.999');



