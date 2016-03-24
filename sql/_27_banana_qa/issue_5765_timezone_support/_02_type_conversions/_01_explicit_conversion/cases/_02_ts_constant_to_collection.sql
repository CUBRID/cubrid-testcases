--cast TIMESTAMP(L)TZ constant values to collection data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to collection types
select cast(timestamp'2019-01-02 12:00:01' as set(timestamp));
select cast(timestamp'2019-01-02 12:00:01' as multiset(timestamp with local time zone));
select cast(timestamp'2019-01-02 12:00:01' as list(timestamp with time zone));
select cast(timestamp'2019-01-02 12:00:01' as sequence(timestamp));

--test: cast ts constant values with time offset to collection types
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as set(timestamp));
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as multiset(timestamp with local time zone));
select cast(timestamptz'2019-01-02 12:00:01 +8:00' as list(timestamp with time zone));
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as sequence(timestamp));

--test: cast ts constant values with geographic time zone to collection types
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as set(timestamp));
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as multiset(timestamp with local time zone));
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as list(timestamp with time zone));
select cast(timestampltz'2019-01-02 12:00:01 America/New_York' as sequence(timestamp));


set timezone 'Asia/Seoul';
