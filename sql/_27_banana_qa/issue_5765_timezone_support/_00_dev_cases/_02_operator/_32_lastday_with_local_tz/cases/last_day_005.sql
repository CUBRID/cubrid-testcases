--marginal values of timestampltz/datetimeltz type


--1. marginal values: timestampltz argument
--select last_day(timestampltz'00:00:00 01/01/2014');
select if(last_day(timestampltz'00:00:00 01/01/2014')=last_day('00:00:00 01/01/2014'),'ok','nok');

select last_day(timestampltz'03:14:07 1/19/2038');

select last_day(timestampltz'0:0:0 PM 1970-01-01');

select last_day(timestampltz'1/19/2038 03:14:07 pm');


--2. marginal values: datetimeltz argument
--select last_day(datetimeltz'0:0:0.00 1/1');
select if(last_day(datetimeltz'0:0:0.00 1/1')=last_day(concat('01/01/',year(sysdate))),'ok','nok');

select last_day(datetimeltz'23:59:59.999 12/31/9999');

select last_day(datetimeltz'00:00:00.0000 AM 0001-01-01');

select last_day(datetimeltz'12/31/9999 23:59:59.999');
