--marginal values of timestamptz/datetimetz type

--1. marginal values: timestamptz argument
--select dayofweek(timestamptz'00:00:00 01/01');
select if(dayofweek(timestampltz'00:00:00 01/01/2014')=dayofweek(timestamptz'00:00:00 01/01/2014'),'ok','nok');

select dayofweek(timestamptz'03:14:07 1/19/2038 Asia/Seoul');

select dayofweek(timestamptz'0:0:0 PM 1970-01-01 Asia/Seoul');

select dayofweek(timestamptz'1/19/2038 03:14:07 pm Asia/Seoul');


--2. marginal values: datetimetz argument
--select dayofweek(datetimetz'0:0:0.00 1/1');
select if(dayofweek(datetimeltz'0:0:0.00 1/1/2014')=dayofweek(datetimetz'0:0:0.00 1/1/2014'),'ok','nok');

select dayofweek(datetimetz'23:59:59.999 12/31/9999 Asia/Seoul');

select dayofweek(datetimetz'00:00:00.0000 AM 0001-01-01 Asia/Seoul');

select dayofweek(datetimetz'12/31/9999 23:59:59.999 Asia/Seoul');
