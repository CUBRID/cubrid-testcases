--marginal values of timetz/timestamptz/datetimetz type

--1. marginal values: timetz argument
select hour(datetimetz'2015-9-17 0:00:00 Asia/Seoul');

select hour(datetimetz'2015-9-17 23:59:59 pm Asia/Seoul');

select hour(datetimetz'2015-9-17 0:0:0 am Asia/Seoul');

select hour(datetimetz'2015-9-17 23:59 Asia/Seoul');

select hour(datetimetz'2015-9-17 00:00 Asia/Seoul');

--error
select hour(datetimetz'2015-9-17 23:59:59 am Asia/Seoul');


--2. marginal values: timestamptz argument
select hour(timestamptz'00:00:00 01/01 Asia/Seoul');

select hour(timestamptz'03:14:07 1/19/2038 Asia/Seoul');

select hour(timestamptz'0:0:0 PM 1970-01-01 Asia/Seoul');

select hour(timestamptz'1/19/2038 03:14:07 pm Asia/Seoul');

select hour(timestamptz'1970-1-1 0:0 Asia/Seoul');

select hour(timestamptz'2038--01-19 3:14:7 Asia/Seoul');


--3. marginal values: datetimetz argument
select hour(datetimetz'0:0:0.00 1/1 Asia/Seoul');

select hour(datetimetz'23:59:59.999 12/31/9999 Asia/Seoul');

select hour(datetimetz'00:00:00.0000 AM 0001-01-01 Asia/Seoul');

select hour(datetimetz'12/31/9999 23:59:59.999 Asia/Seoul');


