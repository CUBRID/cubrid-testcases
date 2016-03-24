--marginal values of timestampltz/datetimeltz type


--1. marginal values: timestampltz argument
--select to_days(timestampltz'00:00:00 01/01');
select if(to_days(timestampltz'00:00:00 01/01/2014')=to_days(timestamptz'00:00:00 01/01/2014'), 'ok','nok');

select to_days(timestampltz'03:14:07 1/19/2038');

select to_days(timestampltz'0:0:0 PM 1970-01-01');

select to_days(timestampltz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimeltz argument
--select to_days(datetimeltz'0:0:0.00 1/1');
select if(to_days(datetimeltz'0:0:0.00 1/1')=to_days(concat('01/01/',year(sysdate))), 'ok','nok');

select to_days(datetimeltz'23:59:59.999 12/31/9999');

select to_days(datetimeltz'00:00:00.0000 AM 0001-01-01');

select to_days(datetimeltz'12/31/9999 23:59:59.999');
