--cast TIME(L)TZ constant values to date/time data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to date/time types
select cast(time'12:00:01' as date);
select cast(time'12:00:01' as time);
select cast(time'12:00:01' as timestamp);
select cast(time'12:00:01' as datetime);

--test: cast ts constant values with time offset to date/time types
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as date);
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as time);
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as timestamp);
select cast(datetimeltz'2015-9-17 12:00:01 +8:00' as datetime);

--test: cast ts constant values with geographic time zone to date/time types
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as date);
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as time);
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as timestamp);
select cast(datetimetz'2015-9-17 12:00:01 America/Regina' as datetime);


set timezone 'Asia/Seoul';
