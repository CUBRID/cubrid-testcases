--marginal values of timestampltz/datetimeltz type

set timezone '+9:00';


--2. marginal values: timestampltz argument
select date(timestampltz'00:00:00 01/01/2014');

select date(timestampltz'03:14:07 1/19/2038');

select date(timestampltz'0:0:0 PM 1970-01-01');

--[er]
select date(timestampltz'1/19/2038 03:14:07 pm');

--[er]
select date(timestampltz'1970-1-1 0:0');

--[er]
select date(timestampltz'2038--01-19 3:14:7');


--3. marginal values: datetimeltz argument
--[er]
select date(datetimeltz'0:0:0:00 01/01/2014');

--[er]
select date(datetimeltz'23:59:59:999 12/31/9999');

--[er]
select date(datetimeltz'00:00:00:0000 AM 0001-01-01');

--[er]
select date(datetimeltz'12/31/9999 23:59:59:999');



select date(datetimeltz'0:0:0.00 01/01/2014');

select date(datetimeltz'23:59:59.999 12/31/9999');

select date(datetimeltz'00:00:00.0000 AM 0001-01-01');

select date(datetimeltz'12/31/9999 23:59:59.999');

set timezone 'Asia/Seoul';
