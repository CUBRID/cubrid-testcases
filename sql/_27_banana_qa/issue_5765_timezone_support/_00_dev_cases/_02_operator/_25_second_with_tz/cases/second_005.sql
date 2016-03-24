--marginal values of timestamptz/datetimetz type


--2. marginal values: timestamptz argument
select second(timestamptz'00:00:00 01/01');

select second(timestamptz'03:14:07 1/19/2038');

select second(timestamptz'0:0:0 PM 1970-01-01');

select second(timestamptz'1/19/2038 03:14:07 pm');

select second(timestamptz'1970-1-1 0:0');

select second(timestamptz'2038--01-19 3:14:7');


--3. marginal values: datetimetz argument
select second(datetimetz'0:0:0.00 1/1');

select second(datetimetz'00:00:00.0000 AM 0001-01-01');
