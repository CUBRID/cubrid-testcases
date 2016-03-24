--marginal values of timestampltz/datetimeltz type

set timezone '+9:00';


--error
select minute('23:59:59 am');


--2. marginal values: timestampltz argument
select minute(timestampltz'00:00:00 01/01');

select minute(timestampltz'03:14:07 1/19/2038');

select minute(timestampltz'0:0:0 PM 1970-01-01');

select minute(timestampltz'1/19/2038 03:14:07 pm');

select minute(timestampltz'1970-1-1 0:0');

select minute(timestampltz'2038--01-19 3:14:7');


--3. marginal values: datetimeltz argument
select minute(datetimeltz'0:0:0.00 1/1');

select minute(datetimeltz'00:00:00.0000 AM 0001-01-01');


set timezone 'Asia/Seoul';
