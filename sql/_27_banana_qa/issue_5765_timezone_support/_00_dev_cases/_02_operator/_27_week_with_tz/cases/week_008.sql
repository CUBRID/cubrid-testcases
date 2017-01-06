--marginal values of timestamptz/datetimetz type


--1. marginal values: timestamptz argument
--select week(timestamptz'00:00:00 01/01');
select if( week(timestamptz'00:00:00 01/01') - week(timestamptz'00:00:00 01/01/2014') in (0,1),'ok','nok');

select week(timestamptz'03:14:07 1/19/2038');

select week(timestamptz'0:0:0 PM 1970-01-01');

select week(timestamptz'1/19/2038 03:14:07 pm');


--2. marginal values: datetimetz argument
--select week(datetimetz'0:0:0.00 1/1');
select if(week(datetimetz'0:0:0.00 1/1')=week(concat('01/01/',year(sysdate))),'ok','nok');

select week(datetimetz'23:59:59.999 12/31/9999');

select week(datetimetz'00:00:00.0000 AM 0001-01-01');

select week(datetimetz'12/31/9999 23:59:59.999');



