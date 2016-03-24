--marginal values of timestampltz/datetimeltz type

--1. marginal values: timestampltz argument
--select weekday(timestampltz'00:00:00 01/01/2014');
select if(weekday(timestampltz'00:00:00 01/01/2014')=weekday(timestampltz'00:00:00 01/01/2014'),'ok','nok');

select weekday(timestampltz'03:14:07 1/19/2038');

select weekday(timestampltz'0:0:0 PM 1970-01-01');

select weekday(timestampltz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimeltz argument
--select weekday(datetimeltz'0:0:0.00 1/1');
select if(weekday(datetimeltz'0:0:0.00 1/1')=weekday(concat('01/01/',year(sysdate))),'ok','nok');
select weekday(datetimeltz'23:59:59.999 12/31/9999');

select weekday(datetimeltz'00:00:00.0000 AM 0001-01-01');

select weekday(datetimeltz'12/31/9999 23:59:59.999');
