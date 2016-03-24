--marginal values of timestampltz/datetimeltz type

--1. marginal values: timestampltz argument
select dayofyear(timestampltz'00:00:00 01/01');

select dayofyear(timestampltz'03:14:07 1/19/2038');

select dayofyear(timestampltz'0:0:0 PM 1970-01-01');

select dayofyear(timestampltz'1/19/2038 03:14:07 pm');


--2. marginal values: datetimeltz argument
select dayofyear(datetimeltz'0:0:0.00 1/1');

select dayofyear(datetimeltz'23:59:59.999 12/31/9999');

select dayofyear(datetimeltz'00:00:00.0000 AM 0001-01-01');

select dayofyear(datetimeltz'12/31/9999 23:59:59.999');
