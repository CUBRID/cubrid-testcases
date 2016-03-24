--marginal values of timestampltz/datetimeltz type

--1. marginal values: timestampltz argument
--select dayofweek(timestampltz'00:00:00 01/01');
select if(dayofweek(timestamptz'00:00:00 01/01/2014')=dayofweek(timestampltz'00:00:00 01/01/2014'),'ok','nok');

select dayofweek(timestampltz'03:14:07 1/19/2038');

select dayofweek(timestampltz'0:0:0 PM 1970-01-01');

select dayofweek(timestampltz'1/19/2038 03:14:07 pm');


--2. marginal values: datetimeltz argument
--select dayofweek(datetimeltz'0:0:0.00 1/1');
select if(dayofweek(datetimetz'0:0:0.00 1/1/2014')=dayofweek(datetimeltz'0:0:0.00 1/1/2014'),'ok','nok');

select dayofweek(datetimeltz'23:59:59.999 12/31/9999');

select dayofweek(datetimeltz'00:00:00.0000 AM 0001-01-01');

select dayofweek(datetimeltz'12/31/9999 23:59:59.999');
