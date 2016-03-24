--cast TIMESTAMP(L)TZ constant values to date/time data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to date/time types
select cast(timestamp'2019-01-02 12:00:01' as date);
select cast(timestamp'2019-01-02 12:00:01' as time);
select cast(timestamp'2019-01-02 12:00:01' as timestamp);
select cast(timestamp'2019-01-02 12:00:01' as datetime);

--test: cast ts constant values with time offset to date/time types
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as date);
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as time);
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as timestamp);
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as datetime);

--test: cast ts constant values with geographic time zone to date/time types
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as date);
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as time);
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as timestamp);
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as datetime);


set timezone 'Asia/Seoul';
