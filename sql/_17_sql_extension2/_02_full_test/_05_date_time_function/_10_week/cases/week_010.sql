--marginal values of date/timestamp/datetime type (2 params)


--1. marginal values: date argument
select week(date'0001-01-01', 0);

select week(date'9999-12-31', 1);

select week(date'12/31/9999', 2);

select week(date'1/1/1', 3);




--2. marginal values: timestamp argument
--select week(timestamp'00:00:00 01/01', 4);
select if(week(timestamp'00:00:00 01/01',4)=week(timestamp(concat('00:00:00 01/01/',year(sysdate))),4),'ok','nok');

select week(timestamp'03:14:07 1/19/2038', 5);

select week(timestamp'0:0:0 PM 1970-01-01', 6);

select week(timestamp'1/19/2038 03:14:07 pm', 7);



--3. marginal values: datetime argument
--select week(datetime'0:0:0.00 1/1', 0);
select if(week(datetime'0:0:0.00 1/1',0)=week(concat('01/01/',year(sysdate))),'ok','nok');

select week(datetime'23:59:59.999 12/31/9999', 2);

select week(datetime'00:00:00.0000 AM 0001-01-01', 4);

select week(datetime'12/31/9999 23:59:59.999', 6);



