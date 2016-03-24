--cast TIMESTAMP(L)TZ constant values to date/time with time zone data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to date/time with local time zone types
select cast(timestampltz'2019-01-02 12:00:01' as timestamp with local time zone);
select cast(timestampltz'2019-01-02 12:00:01' as datetime with local time zone);
--test: cast ts constant values to date/time with time zone types
select cast(timestampltz'2019-01-02 12:00:01' as timestamp with time zone);
select cast(timestampltz'2019-01-02 12:00:01' as datetime with time zone);

--test: cast ts constant values with time offset to date/time with local time zone types
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as timestamp with local time zone);
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as datetime with local time zone);
--test: cast ts constant values with time offset to date/time with time zone types
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as timestamp with time zone);
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as datetime with time zone);

--test: cast ts constant values with geographic time zone to date/time with local time zone types
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as timestamp with local time zone);
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as datetime with local time zone);
--test: cast ts constant values with geographic time zone to date/time with time zone types
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as timestamp with time zone);
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as datetime with time zone);


set timezone 'Asia/Seoul';
