--marginal values of timestamptz/datetimetz type

--1. marginal values: timestamptz argument
select quarter(timestamptz'00:00:00 01/01 Europe/London');

select quarter(timestamptz'03:14:07 1/19/2038 Europe/Paris');

select quarter(timestamptz'0:0:0 PM 1970-01-01 Asia/Seoul');

select quarter(timestamptz'1/19/2038 03:14:07 pm Europe/Zurich');

--2. marginal values: datetimetz argument
select quarter(datetimetz'0:0:0.00 1/1 Europe/London');

select quarter(datetimetz'23:59:59.999 12/31/9999 Europe/Paris');

select quarter(datetimetz'00:00:00.0000 AM 0001-01-01 Asia/Seoul');

select quarter(datetimetz'12/31/9999 23:59:59.999 Europe/Zurich');


--[er]
select quarter(datetimetz'0:0:0:00 1/1 Europe/London');
