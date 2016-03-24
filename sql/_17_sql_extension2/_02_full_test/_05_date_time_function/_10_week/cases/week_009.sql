--marginal values (2 params)


--1. marginal values: string type of date format
select week('0001-01-01', 0);

select week('9999-12-31', 1);

select week('12/31/9999', 2);

select week('1/1/1', 3);




--2. marginal values: string type of timestamp format
--select week('00:00:00 01/01', 4);
select if(week('00:00:00 01/01', 4)=week(concat('00:00:00 01/01/',year(sysdate)),4),'ok','nok');

select week('03:14:07 1/19/2038', 5);

select week('0:0:0 PM 1970-01-01', 6);

select week('1/19/2038 03:14:07 pm', 7);


--3. marginal values: string type of datetime format
--select week('0:0:0.00 1/1', 0);
select if(week('0:0:0.00 1/1', 0)=week(concat('0:0:0.00 1/1/',year(sysdate)),0),'ok','nok');

select week('23:59:59.999 12/31/9999', 1);

select week('00:00:00.0000 AM 0001-01-01', 2);

select week('12/31/9999 23:59:59.999', 3);



