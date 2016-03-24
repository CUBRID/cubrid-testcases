--pass out-of-range data of timestampltz/datetimeltz type to the parameter



--2. [error] out-of-range argument:  timestampltz type
select minute(timestampltz'23:00:00 13/01');

select minute(timestampltz'04:14:07 1/19/2038');

select minute(timestampltz'03:15:07 1/19/2038');

select minute(timestampltz'03:14:08 1/19/2038');

select minute(timestampltz'03:14:07 2/19/2038');

select minute(timestampltz'03:14:07 1/20/2038');

select minute(timestampltz'03:14:07 1/19/2039');

--??
select minute(timestampltz'03:14:07 PM 1/19/2038');

select minute(timestampltz'0:0:0 PM 1969-01-01');

select minute(timestampltz'11:03:22 PM 1864-01-23');

select minute(timestampltz'2300-12-12 22:02:33');

select minute(timestampltz'2020-23-11 03:14:66 pm');

select minute(timestampltz'1970-10-101 0:0');

select minute(timestampltz'1999/12/11 3:14:7 am');

select minute(timestampltz'2010-4-31 3:14:7 am');



--3. [error] out-of-range argument: datetimeltz type
select minute(datetimeltz'2010-10 10:10:100.00 am');

select minute(datetimeltz'24:59:59.999 12/31/9999');

select minute(datetimeltz'23:60:59.999 12/31/9999');

select minute(datetimeltz'23:59:60.999 12/31/9999');

select minute(datetimeltz'23:59:59.999 13/31/9999');

select minute(datetimeltz'23:59:59.999 12/32/9999');

select minute(datetimeltz'23:59:59.999 12/31/10000');

select minute(datetimeltz'20:33:61.111 1990-10-19 ');

select minute(datetimeltz'2/31/2022 10:20:30.400');

select minute(datetimeltz'0-12-12 23:59:59.999');
