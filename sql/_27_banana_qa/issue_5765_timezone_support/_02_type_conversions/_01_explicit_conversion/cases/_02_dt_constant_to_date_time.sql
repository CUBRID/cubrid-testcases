--cast DATETIME(L)TZ constant values to date/time data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to date/time types
select cast(datetime'2019-01-02 12:00:01.999' as date);
select cast(datetime'2019-01-02 12:00:01.999' as time);
select cast(datetime'2019-01-02 12:00:01.999' as datetime);
select cast(datetime'2019-01-02 12:00:01.999' as datetime);

--test: cast ts constant values with time offset to date/time types
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as date);
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as time);
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as datetime);
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as datetime);

--test: cast ts constant values with geographic time zone to date/time types
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as date);
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as time);
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as datetime);
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as datetime);


set timezone 'Asia/Seoul';
