--marginal values of timestamptz/datetimetz type


--2. marginal values: timestamptz argument
select date(timestamptz'00:00:00 01/01/2014');

select date(timestamptz'03:14:07 1/19/2038');

select date(timestamptz'0:0:0 PM 1970-01-01');

--[er]
select date(timestamptz'1/19/2038 03:14:07 pm');

--[er]
select date(timestamptz'1970-1-1 0:0');

--[er]
select date(timestamptz'2038--01-19 3:14:7');


--3. marginal values: datetimetz argument
--[er]
select date(datetimetz'0:0:0:00 01/01/2014');

--[er]
select date(datetimetz'23:59:59:999 12/31/9999');

--[er]
select date(datetimetz'00:00:00:0000 AM 0001-01-01');

--[er]
select date(datetimetz'12/31/9999 23:59:59:999');



select date(datetimetz'0:0:0.00 01/01/2014');

select date(datetimetz'23:59:59.999 12/31/9999');

select date(datetimetz'00:00:00.0000 AM 0001-01-01');

select date(datetimetz'12/31/9999 23:59:59.999');
