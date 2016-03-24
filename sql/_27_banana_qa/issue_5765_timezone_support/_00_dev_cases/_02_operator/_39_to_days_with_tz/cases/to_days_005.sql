--marginal values of timestamptz/datetimetz type


--1. marginal values: timestamptz argument
--select to_days(timestamptz'00:00:00 01/01');
select if(to_days(timestamptz'00:00:00 01/01/2014')=to_days(timestampltz'00:00:00 01/01/2014'), 'ok','nok');

select to_days(timestamptz'03:14:07 1/19/2038');

select to_days(timestamptz'0:0:0 PM 1970-01-01');

select to_days(timestamptz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimetz argument
--select to_days(datetimetz'0:0:0.00 1/1');
select if(to_days(datetimetz'0:0:0.00 1/1')=to_days(concat('01/01/',year(sysdate))), 'ok','nok');

select to_days(datetimetz'23:59:59.999 12/31/9999');

select to_days(datetimetz'00:00:00.0000 AM 0001-01-01');

select to_days(datetimetz'12/31/9999 23:59:59.999');
