--marginal values of timestampltz/datetimeltz type

--1. marginal values: timestampltz argument
select day(timestampltz'00:00:00 01/01');

select day(timestampltz'03:14:07 1/19/2038');

select day(timestampltz'0:0:0 PM 1970-01-01');

select day(timestampltz'1/19/2038 03:14:07 pm');



--2. marginal values: datetimeltz argument
select day(datetimeltz'0:0:0.00 1/1');

select day(datetimeltz'23:59:59.999 12/31/9999');

select day(datetimeltz'00:00:00.0000 AM 0001-01-01');

select day(datetimeltz'12/31/9999 23:59:59.999');
