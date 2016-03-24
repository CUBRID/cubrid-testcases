--pass out-of-range data of timestampltz/datetimeltz type to the parameter


--2. [error] out-of-range argument:  timestampltz type
select date(timestampltz'23:00:00 13/01');

select date(timestampltz'04:14:07 1/19/9999');

select date(timestampltz'23:59:59:999 12/31/10000');

select date(timestampltz'2/31/2022 10:20:30:400');

select date(timestampltz'0-12-12 23:59:59:999');

select date(timestampltz'12/31/9999 23:59:59:999');

--3. [error] out-of-range argument: datetimeltz type
select date(datetimeltz'2010-10 10:10:100:00 am');

select date(datetimeltz'24:59:59:999 12/31/9999');

select date(datetimeltz'23:60:59:999 12/31/9999');

select date(datetimeltz'23:59:60:999 12/31/9999');

select date(datetimeltz'23:59:59:999 12/31/10000');

select date(datetimeltz'20:33:61:111 1990-10-19');

select date(datetimeltz'2/31/2022 10:20:30:400');

select date(datetimeltz'12/31/9999 23:59:59:999');

select date(datetimeltz'0-12-12 23:59:59:999');

