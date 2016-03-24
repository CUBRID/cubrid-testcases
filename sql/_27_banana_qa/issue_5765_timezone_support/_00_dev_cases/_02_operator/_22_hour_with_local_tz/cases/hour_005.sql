--marginal values of timeltz/timestampltz/datetimeltz type

set timezone '+9:00';


--2. marginal values: timestampltz argument
select hour(timestampltz'00:00:00 01/01');

select hour(timestampltz'03:14:07 1/19/2038');

select hour(timestampltz'0:0:0 PM 1970-01-01');

select hour(timestampltz'1/19/2038 03:14:07 pm');

select hour(timestampltz'1970-1-1 0:0');

select hour(timestampltz'2038--01-19 3:14:7');


--3. marginal values: datetimeltz argument
select hour(datetimeltz'0:0:0.00 1/1');

select hour(datetimeltz'23:59:59.999 12/31/9999');

select hour(datetimeltz'00:00:00.0000 AM 0001-01-01');

select hour(datetimeltz'12/31/9999 23:59:59.999');

set timezone 'Asia/Seoul';
