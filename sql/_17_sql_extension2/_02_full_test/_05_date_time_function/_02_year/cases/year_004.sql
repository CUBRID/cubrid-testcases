--marginal values


--1. marginal values: string type of date format
select year('0001-01-01');

select year('9999-12-31');

select year('12/31/9999');

select year('1/1/1');




--2. marginal values: string type of timestamp format
--select year('00:00:00 01/01');
select if(year('00:00:00 01/01')=year(sysdate),'ok','nok');

select year('03:14:07 1/19/2038');

select year('0:0:0 PM 1970-01-01');

select year('1/19/2038 03:14:07 pm');


--3. marginal values: string type of datetime format
--select year('0:0:0.00 1/1');
select if(year('0:0:0.00 1/1')=year(sysdate),'ok','nok');

select year('23:59:59.999 12/31/9999');

select year('00:00:00.0000 AM 0001-01-01');

select year('12/31/9999 23:59:59.999');


--4. [er] others
select year('1:2:3:4 2000-12-12');

select year('10:2:3:4 2000-12-12');

select year('200:2:3:4 1999-12-12');

select year('12:2:3:4 2000-12-12');

select year('1:1:1.1 2000');



