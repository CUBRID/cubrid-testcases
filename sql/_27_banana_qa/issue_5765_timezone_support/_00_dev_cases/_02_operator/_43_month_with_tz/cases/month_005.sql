--marginal values of timestamptz/datetimetz type


--1. marginal values: timestamptz argument
select month(timestamptz'00:00:00 01/01');

select month(timestamptz'03:14:07 1/19/2038');

select month(timestamptz'0:0:0 PM 1970-01-01');

select month(timestamptz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimetz argument
select month(datetimetz'0:0:0.00 1/1');

select month(datetimetz'23:59:59.999 12/31/9999');

select month(datetimetz'00:00:00.0000 AM 0001-01-01');

select month(datetimetz'12/31/9999 23:59:59.999');
