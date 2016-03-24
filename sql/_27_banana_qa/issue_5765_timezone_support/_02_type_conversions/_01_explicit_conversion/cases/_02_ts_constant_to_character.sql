--cast TIMESTAMP(L)TZ constant values to character string data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to character string types
select cast(timestamp'2019-01-02 12:00:01' as char(10));
select cast(timestamp'2019-01-02 12:00:01' as char(40));
select cast(timestamp'2019-01-02 12:00:01' as varchar(10));
select cast(timestamp'2019-01-02 12:00:01' as varchar(40));
select cast(timestamp'2019-01-02 12:00:01' as string);
--test: cast ts constant values to character enum type
select cast(timestamp'2019-01-02 12:00:01' as enum('a', 'b', 'c'));
select cast(timestamp'2019-01-02 12:00:01' as enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 UTC'));

--test: cast ts constant values with time offset to character string types
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as char(20));
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as char(40));
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as varchar(20));
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as varchar(40));
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as string);
--test: cast ts constant values with time offset to enum type
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as enum('a', 'b', 'c'));
select cast(timestampltz'2019-01-02 12:00:01 +8:00' as enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '01:00:01 PM 01/02/2019 Asia/Seoul', '12:00:01 PM 01/02/2019 UTC'));

--test: cast ts constant values with geographic time zone to character string types
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as char(20));
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as char(50));
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as varchar(20));
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as varchar(50));
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as string);
--test: cast ts constant values with geographic time zone to enum type
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as enum('a', 'b', 'c'));
select cast(timestamptz'2019-01-02 12:00:01 America/New_York' as enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 America/New_York EST', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 UTC'));


set timezone 'Asia/Seoul';
