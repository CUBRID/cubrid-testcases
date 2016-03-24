--marginal values of timestamptz/datetimetz type

--1. marginal values: timestamptz argument
select dayofyear(timestamptz'00:00:00 01/01 Asia/Seoul');

select dayofyear(timestamptz'03:14:07 1/19/2038 Asia/Seoul');

select dayofyear(timestamptz'0:0:0 PM 1970-01-01 Asia/Seoul');

select dayofyear(timestamptz'1/19/2038 03:14:07 pm Asia/Seoul');


--2. marginal values: datetimetz argument
select dayofyear(datetimetz'0:0:0.00 1/1 Asia/Seoul');

select dayofyear(datetimetz'23:59:59.999 12/31/9999 Asia/Seoul');

select dayofyear(datetimetz'00:00:00.0000 AM 0001-01-01 Asia/Seoul');

select dayofyear(datetimetz'12/31/9999 23:59:59.999 Asia/Seoul');
