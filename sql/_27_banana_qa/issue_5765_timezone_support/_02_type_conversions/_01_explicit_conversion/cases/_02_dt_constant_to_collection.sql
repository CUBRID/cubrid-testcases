--cast DATETIME(L)TZ constant values to collection data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to collection types
select cast(datetime'2019-01-02 12:00:01.999' as set(datetime));
select cast(datetime'2019-01-02 12:00:01.999' as multiset(datetime with local time zone));
select cast(datetime'2019-01-02 12:00:01.999' as list(datetime with time zone));
select cast(datetime'2019-01-02 12:00:01.999' as sequence(datetime));

--test: cast ts constant values with time offset to collection types
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as set(datetime));
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as multiset(datetime with local time zone));
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as list(datetime with time zone));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as sequence(datetime));

--test: cast ts constant values with geographic time zone to collection types
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as set(datetime));
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as multiset(datetime with local time zone));
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as list(datetime with time zone));
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as sequence(datetime));


set timezone 'Asia/Seoul';
