--marginal values of timestampltz/datetimeltz type

set timezone '+9:00';


--2. marginal values: timestampltz argument
select second(timestampltz'00:00:00 01/01');

select second(timestampltz'03:14:07 1/19/2038');

select second(timestampltz'0:0:0 PM 1970-01-01');

select second(timestampltz'1/19/2038 03:14:07 pm');

select second(timestampltz'1970-1-1 0:0');

select second(timestampltz'2038--01-19 3:14:7');


--3. marginal values: datetimeltz argument
select second(datetimeltz'0:0:0.00 1/1');

select second(datetimeltz'00:00:00.0000 AM 0001-01-01');

set timezone 'Asia/Seoul';
