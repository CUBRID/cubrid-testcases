--cast TIME(L)TZ constant values to bit/lob data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to bit/blob/clob types
select cast(time'12:00:01' as bit(20));
select cast(time'12:00:01' as bit varying);
select blob_to_bit(cast(time'12:00:01' as blob));
select clob_to_char(cast(time'12:00:01' as clob));

--test: cast ts constant values with time offset to bit/blob/clob types
select blob_to_bit(cast(datetimeltz'2015-9-17 12:00:01 +8:00' as blob));
select clob_to_char(cast(datetimeltz'2015-9-17 12:00:01 +8:00' as clob));

--test: cast ts constant values with geographic time zone to bit/blob/clob types
select cast(datetimetz'2015-9-17 12:00:01 America/New_York' as bit(20));
select cast(datetimetz'2015-9-17 12:00:01 America/New_York' as bit varying);
select blob_to_bit(cast(datetimetz'2015-9-17 12:00:01 America/New_York' as blob));
select clob_to_char(cast(datetimetz'2015-9-17 12:00:01 America/New_York' as clob));


set timezone 'Asia/Seoul';
