--cast DATETIME(L)TZ constant values to bit/lob data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to bit/blob/clob types
select cast(datetime'2019-01-02 12:00:01.999' as bit(20));
select cast(datetime'2019-01-02 12:00:01.999' as bit varying);
select blob_to_bit(cast(datetime'2019-01-02 12:00:01.999' as blob));
select clob_to_char(cast(datetime'2019-01-02 12:00:01.999' as clob));

--test: cast ts constant values with time offset to bit/blob/clob types
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as bit(20));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as bit varying);
select blob_to_bit(cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as blob));
select clob_to_char(cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as clob));

--test: cast ts constant values with geographic time zone to bit/blob/clob types
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as bit(20));
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as bit varying);
select blob_to_bit(cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as blob));
select clob_to_char(cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as clob));


set timezone 'Asia/Seoul';
