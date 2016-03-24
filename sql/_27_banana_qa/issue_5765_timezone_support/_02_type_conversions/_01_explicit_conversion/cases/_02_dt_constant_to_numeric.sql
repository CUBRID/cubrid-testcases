--cast DATETIME(L)TZ constant values to numeric data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to numeric types
select cast(datetime'2019-01-02 12:00:01.999' as short);
select cast(datetime'2019-01-02 12:00:01.999' as int);
select cast(datetime'2019-01-02 12:00:01.999' as bigint);
select cast(datetime'2019-01-02 12:00:01.999' as numeric(4, 2));
select cast(datetime'2019-01-02 12:00:01.999' as float);
select cast(datetime'2019-01-02 12:00:01.999' as double);

--test: cast ts constant values with time offset to numeric types
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as short);
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as int);
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as bigint);
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as numeric(4, 2));
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as float);
select cast(datetimetz'2019-01-02 12:00:01.999 +8:00' as double);

--test: cast ts constant values with geographic time zone to numeric types
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as short);
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as int);
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as bigint);
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as numeric(4, 2));
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as float);
select cast(datetimeltz'2019-01-02 12:00:01.999 America/New_York' as double);


set timezone 'Asia/Seoul';
