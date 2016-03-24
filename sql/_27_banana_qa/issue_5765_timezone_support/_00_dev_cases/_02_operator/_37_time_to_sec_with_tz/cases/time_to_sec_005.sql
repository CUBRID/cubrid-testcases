--marginal values of timestamptz/datetimetz type


--error
select time_to_sec('23:59:59 am');



--2. marginal values: timestamptz argument
select time_to_sec(timestamptz'00:00:00 01/01');

select time_to_sec(timestamptz'03:14:07 1/19/2038');

select time_to_sec(timestamptz'0:0:0 PM 1970-01-01');

select time_to_sec(timestamptz'1/19/2038 03:14:07 pm');

select time_to_sec(timestamptz'1970-1-1 0:0');

select time_to_sec(timestamptz'2038--01-19 3:14:7');


--3. marginal values: datetimetz argument
select time_to_sec(datetimetz'0:0:0.00 1/1');

select time_to_sec(datetimetz'00:00:00.0000 AM 0001-01-01');
