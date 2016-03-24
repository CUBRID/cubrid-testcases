--marginal values of timestamptz/datetimetz type


--1. marginal values: timestamptz argument
--select last_day(timestamptz'00:00:00 01/01/2014');
select if(last_day(timestamptz'00:00:00 01/01/2014')=last_day('00:00:00 01/01/2014'),'ok','nok');

select last_day(timestamptz'03:14:07 1/19/2038');

select last_day(timestamptz'0:0:0 PM 1970-01-01');

select last_day(timestamptz'1/19/2038 03:14:07 pm');


--2. marginal values: datetimetz argument
--select last_day(datetimetz'0:0:0.00 1/1');
select if(last_day(datetimetz'0:0:0.00 1/1')=last_day(concat('01/01/',year(sysdate))),'ok','nok');

select last_day(datetimetz'23:59:59.999 12/31/9999');

select last_day(datetimetz'00:00:00.0000 AM 0001-01-01');

select last_day(datetimetz'12/31/9999 23:59:59.999');
