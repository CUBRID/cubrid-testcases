--marginal values of timestamptz/datetimetz type

--1. marginal values: timestamptz argument
--select weekday(timestamptz'00:00:00 01/01');
select if(weekday(timestamptz'00:00:00 01/01/2014')=weekday(timestampltz'00:00:00 01/01/2014'),'ok','nok');

select weekday(timestamptz'03:14:07 1/19/2038');

select weekday(timestamptz'0:0:0 PM 1970-01-01');

select weekday(timestamptz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimetz argument
--select weekday(datetimetz'0:0:0.00 1/1');
select if(weekday(datetimetz'0:0:0.00 1/1')=weekday(concat('01/01/',year(sysdate))),'ok','nok');
select weekday(datetimetz'23:59:59.999 12/31/9999');

select weekday(datetimetz'00:00:00.0000 AM 0001-01-01');

select weekday(datetimetz'12/31/9999 23:59:59.999');
