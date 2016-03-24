--cast TIMESTAMP(L)TZ constant values to numeric data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to numeric types
select cast(timestamp'2019-01-02 12:00:01' as short);
select cast(timestamp'2019-01-02 12:00:01' as int);
select cast(timestamp'2019-01-02 12:00:01' as bigint);
select cast(timestamp'2019-01-02 12:00:01' as numeric(4, 2));
select cast(timestamp'2019-01-02 12:00:01' as float);
select cast(timestamp'2019-01-02 12:00:01' as double);

--test: cast ts constant values with time offset to numeric types
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as short);
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as int);
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as bigint);
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as numeric(4, 2));
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as float);
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as double);

--test: cast ts constant values with geographic time zone to numeric types
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as short);
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as int);
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as bigint);
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as numeric(4, 2));
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as float);
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as double);


set timezone 'Asia/Seoul';
