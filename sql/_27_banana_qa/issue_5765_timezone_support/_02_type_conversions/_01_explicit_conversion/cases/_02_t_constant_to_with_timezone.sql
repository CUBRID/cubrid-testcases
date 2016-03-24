--cast TIME(L)TZ constant values to date/time with time zone data types


set timezone '+9:00';

--test: cast ts constant values to date/time with local time zone types
select cast(datetimeltz'2015-9-17 12:00:01' as timestamp with local time zone);
select cast(datetimeltz'2015-9-17 12:00:01' as datetime with local time zone);
--test: cast ts constant values to date/time with time zone types
select cast(datetimeltz'2015-9-17 12:00:01' as timestamp with time zone);
select cast(datetimeltz'2015-9-17 12:00:01' as datetime with time zone);

--test: cast ts constant values with time offset to date/time with local time zone types
select cast(datetimetz'2015-9-17 12:00:01 +8:00' as timestamp with local time zone);
select cast(datetimetz'2015-9-17 12:00:01 +8:00' as datetime with local time zone);
--test: cast ts constant values with time offset to date/time with time zone types
select cast(datetimetz'2015-9-17 12:00:01 +8:00' as timestamp with time zone);
select cast(datetimetz'2015-9-17 12:00:01 +8:00' as datetime with time zone);

--test: cast ts constant values with geographic time zone to date/time with local time zone types
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as timestamp with local time zone);
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as datetime with local time zone);
--test: cast ts constant values with geographic time zone to date/time with time zone types
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as timestamp with time zone);
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as datetime with time zone);


set timezone 'Asia/Seoul';
