--marginal values of timestamptz/datetimetz type


--2. marginal values: timestamptz argument
select minute(timestamptz'00:00:00 01/01 Asia/Seoul');

select minute(timestamptz'03:14:07 1/19/2038 Asia/Seoul');

select minute(timestamptz'0:0:0 PM 1970-01-01 Asia/Seoul');

select minute(timestamptz'1/19/2038 03:14:07 pm Asia/Seoul');

select minute(timestamptz'1970-1-1 0:0 Asia/Seoul');

select minute(timestamptz'2038--01-19 3:14:7 Asia/Seoul');


--3. marginal values: datetimetz argument
select minute(datetimetz'0:0:0.00 1/1 Asia/Seoul');

select minute(datetimetz'23:59:59.999 12/31/9999 Asia/Seoul');

select minute(datetimetz'00:00:00.0000 AM 0001-01-01 Asia/Seoul');

select minute(datetimetz'12/31/9999 23:59:59.999 Asia/Seoul');
