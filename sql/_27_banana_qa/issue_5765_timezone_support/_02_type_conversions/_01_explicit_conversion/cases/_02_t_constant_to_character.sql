--cast TIME(L)TZ constant values to character string data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to character string types
select cast(time'12:00:01' as char(10));
select cast(time'12:00:01' as char(20));
select cast(time'12:00:01' as varchar(10));
select cast(time'12:00:01' as varchar(20));
select cast(time'12:00:01' as string);
--test: cast ts constant values to character enum type
select cast(time'12:00:01' as enum('a', 'b', 'c'));
select cast(time'12:00:01' as enum('12:00:01 PM', '2015-9-17 12:00:01 PM +08:00', '2015-9-17 12:00:01 PM -10:00', '2015-9-17 12:00:01 PM Asia/Seoul', '2015-9-17 12:00:01 PM +00:00'));

--test: cast ts constant values with time offset to character string types
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as char(20));
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as char(50));
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as varchar(20));
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as varchar(50));
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as string);
--test: cast ts constant values with time offset to enum type
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as enum('a', 'b', 'c'));
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as enum('12:00:01 PM', '2015-9-17 12:00:01 PM +08:00', '2015-9-17 12:00:01 PM -10:00', '01:00:01 PM Asia/Seoul', '2015-9-17 12:00:01 PM +00:00'));

--test: cast ts constant values with geographic time zone to character string types
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as char(10));
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as char(50));
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as varchar(10));
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as varchar(50));
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as string);
--test: cast ts constant values with geographic time zone to enum type
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as enum('a', 'b', 'c'));
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as enum('12:00:01 PM', '2015-9-17 12:00:01 PM +08:00', '2015-9-17 12:00:01 PM -06:00', '2015-9-17 12:00:01 PM Asia/Tokyo', '2015-9-17 12:00:01 PM +00:00'));


set timezone 'Asia/Seoul';
