--pass out-of-range data of timestamptz/datetimetz type to the parameter


--2. [error] out-of-range argument:  timestamptz type
select date(timestamptz'23:00:00 13/01');

select date(timestamptz'04:14:07 1/19/9999');

select date(timestamptz'23:59:59:999 12/31/10000');

select date(timestamptz'2/31/2022 10:20:30:400');

select date(timestamptz'0-12-12 23:59:59:999');

select date(timestamptz'12/31/9999 23:59:59:999');

--3. [error] out-of-range argument: datetimetz type
select date(datetimetz'2010-10 10:10:100:00 am');

select date(datetimetz'24:59:59:999 12/31/9999');

select date(datetimetz'23:60:59:999 12/31/9999');

select date(datetimetz'23:59:60:999 12/31/9999');

select date(datetimetz'23:59:59:999 12/31/10000');

select date(datetimetz'20:33:61:111 1990-10-19');

select date(datetimetz'2/31/2022 10:20:30:400');

select date(datetimetz'12/31/9999 23:59:59:999');

select date(datetimetz'0-12-12 23:59:59:999');
