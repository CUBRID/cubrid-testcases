--marginal values of timestamptz/datetimetz type


--1. marginal values: timestamptz argument
--select year(timestamptz'00:00:00 01/01');
select if(year(timestamptz'00:00:00 01/01')=year(sysdate),'ok','nok');

select year(timestamptz'03:14:07 1/19/2038');

select year(timestamptz'0:0:0 PM 1970-01-01');

select year(timestamptz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimetz argument
--select year(datetimetz'0:0:0.00 1/1');
select if(year(datetimetz'0:0:0.00 1/1')=year(sysdate),'ok','nok');

select year(datetimetz'23:59:59.999 12/31/9999');

select year(datetimetz'00:00:00.0000 AM 0001-01-01');

select year(datetimetz'12/31/9999 23:59:59.999');

--[er]
select year(datetimetz'1:2:3:4 2000-12-12');
