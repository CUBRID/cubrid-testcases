--marginal values of timestampltz/datetimeltz type

set timezone '+9:00';

--2. marginal values: timestampltz argument
select time_to_sec(timestampltz'00:00:00 01/01');

select time_to_sec(timestampltz'03:14:07 1/19/2038');

select time_to_sec(timestampltz'0:0:0 PM 1970-01-01');

select time_to_sec(timestampltz'1/19/2038 03:14:07 pm');

select time_to_sec(timestampltz'1970-1-1 0:0');

select time_to_sec(timestampltz'2038--01-19 3:14:7');


--3. marginal values: datetimeltz argument
select time_to_sec(datetimeltz'0:0:0.00 1/1');

select time_to_sec(datetimeltz'00:00:00.0000 AM 0001-01-01');

set timezone 'Asia/Seoul';
