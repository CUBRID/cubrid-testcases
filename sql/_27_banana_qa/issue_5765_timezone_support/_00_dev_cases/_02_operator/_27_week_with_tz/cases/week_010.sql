--marginal values of timestamptz/datetimetz type (2 params)


--1. marginal values: timestamptz argument
--select week(timestamptz'00:00:00 01/01', 4);
select if(week(timestamptz'00:00:00 01/01/2014',4)=week(timestampltz'00:00:00 01/01/2014',4),'ok','nok');

select week(timestamptz'03:14:07 1/19/2038', 5);

select week(timestamptz'0:0:0 PM 1970-01-01', 6);

select week(timestamptz'1/19/2038 03:14:07 pm', 7);



--2. marginal values: datetimetz argument
--select week(datetimetz'0:0:0.00 1/1', 0);
select if(week(datetimetz'0:0:0.00 1/1',0)=week(concat('01/01/',year(sysdate))),'ok','nok');

select week(datetimetz'23:59:59.999 12/31/9999', 2);

select week(datetimetz'00:00:00.0000 AM 0001-01-01', 4);

select week(datetimetz'12/31/9999 23:59:59.999', 6);



