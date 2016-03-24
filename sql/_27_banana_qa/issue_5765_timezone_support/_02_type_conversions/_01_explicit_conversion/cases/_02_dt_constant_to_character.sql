--cast DATETIME(L)TZ constant values to character string data types


set timezone 'Asia/Seoul';

--test: cast ts constant values to character string types
select cast(datetime'2019-01-02 12:00:01.999' as char(10));
select cast(datetime'2019-01-02 12:00:01.999' as char(40));
select cast(datetime'2019-01-02 12:00:01.999' as varchar(10));
select cast(datetime'2019-01-02 12:00:01.999' as varchar(40));
select cast(datetime'2019-01-02 12:00:01.999' as string);
--test: cast ts constant values to character enum type
select cast(datetime'2019-01-02 12:00:01.999' as enum('a', 'b', 'c'));
select cast(datetime'2019-01-02 12:00:01.999' as enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 UTC'));

--test: cast ts constant values with time offset to character string types
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as char(20));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as char(40));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as varchar(20));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as varchar(40));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as string);
--test: cast ts constant values with time offset to enum type
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as enum('a', 'b', 'c'));
select cast(datetimeltz'2019-01-02 12:00:01.999 +8:00' as enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 -10:00', '01:00:01.999 PM 01/02/2019 Asia/Seoul', '12:00:01.999 PM 01/02/2019 UTC'));

--test: cast ts constant values with geographic time zone to character string types
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as char(20));
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as char(50));
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as varchar(20));
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as varchar(50));
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as string);
--test: cast ts constant values with geographic time zone to enum type
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as enum('a', 'b', 'c'));
select cast(datetimetz'2019-01-02 12:00:01.999 America/New_York' as enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 America/New_York EST', '12:00:01.999 PM 01/02/2019 Asia/Tokyo', '12:00:01.999 PM 01/02/2019 UTC'));


set timezone 'Asia/Seoul';
