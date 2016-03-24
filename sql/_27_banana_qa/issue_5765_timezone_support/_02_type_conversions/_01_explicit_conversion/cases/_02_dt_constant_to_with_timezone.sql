--cast DATETIME(L)TZ constant values to date/time with time zone data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to date/time with local time zone types
select cast(datetimeltz'2019-01-02 12:00:01.999' as datetime with local time zone);
select cast(datetimeltz'2019-01-02 12:00:01.999' as datetime with local time zone);
--test: cast ts constant values to date/time with time zone types
select cast(datetimeltz'2019-01-02 12:00:01.999' as datetime with time zone);
select cast(datetimeltz'2019-01-02 12:00:01.999' as datetime with time zone);

--test: cast ts constant values with time offset to date/time with local time zone types
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as datetime with local time zone);
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as datetime with local time zone);
--test: cast ts constant values with time offset to date/time with time zone types
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as datetime with time zone);
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as datetime with time zone);

--test: cast ts constant values with geographic time zone to date/time with local time zone types
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as datetime with local time zone);
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as datetime with local time zone);
--test: cast ts constant values with geographic time zone to date/time with time zone types
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as datetime with time zone);
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as datetime with time zone);


set timezone 'Asia/Seoul';
