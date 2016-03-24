--marginal values of timestampltz/datetimeltz type


--1. marginal values: timestampltz argument
--select year(timestampltz'00:00:00 01/01');
select if(year(timestampltz'00:00:00 01/01')=year(sysdate),'ok','nok');

select year(timestampltz'03:14:07 1/19/2038');

select year(timestampltz'0:0:0 PM 1970-01-01');

select year(timestampltz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimeltz argument
--select year(datetimeltz'0:0:0.00 1/1');
select if(year(datetimeltz'0:0:0.00 1/1')=year(sysdate),'ok','nok');

select year(datetimeltz'23:59:59.999 12/31/9999');

select year(datetimeltz'00:00:00.0000 AM 0001-01-01');

select year(datetimeltz'12/31/9999 23:59:59.999');

--[er]
select year(datetimeltz'1:2:3:4 2000-12-12');
