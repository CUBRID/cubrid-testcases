drop table if exists t1;
create table t1(
	c_short short,
	c_int int,
	c_bigint bigint,
	c_date date,
	c_time time,
	c_timestamp timestamp,
	c_datetime datetime,
	c_timestampltz timestamp with local time zone,
	c_timestamptz timestamp with time zone,
	c_datetimeltz datetime with local time zone,
	c_datetimetz datetime with time zone
);

insert into t1 values(
	10, 99, 12345678, 
	date'2020-12-12', time'23:59:59', timestamp'1999-04-23 14:35:56', datetime'1999-04-23 14:35:56.789',
	timestampltz'2033-10-01 12:13:14 -12:00', timestamptz'2033-10-01 12:13:14 Europe/Riga',
	datetimeltz'1823-12-31 23:59:59 +14:00', datetimetz'2099-11-23 12:00:00 AM Australia/Eucla'
);
--when biginit is 12345678, return NULL
select REPEAT( c_date, c_bigint ) from t1;   
select REPEAT( c_time, c_bigint ) from t1;  
select REPEAT( c_timestamp, c_bigint ) from t1;    
select REPEAT( c_datetime, c_bigint ) from t1;   
select REPEAT( c_timestampltz , c_bigint ) from t1; 
select REPEAT( c_timestamptz, c_bigint ) from t1;  
select REPEAT( c_datetimeltz, c_bigint ) from t1; 
select REPEAT( c_datetimetz, c_bigint ) from t1;

drop table t1; 

drop table if exists t1;
create table t1(
        c_short short,
        c_int int,
        c_bigint bigint,
        c_date date,
        c_time time,
        c_timestamp timestamp,
        c_datetime datetime,
        c_timestampltz timestamp with local time zone,
        c_timestamptz timestamp with time zone,
        c_datetimeltz datetime with local time zone,
        c_datetimetz datetime with time zone
);

insert into t1 values(
        10, 99, 123456789,
        date'2020-12-12', time'23:59:59', timestamp'1999-04-23 14:35:56', datetime'1999-04-23 14:35:56.789',
        timestampltz'2033-10-01 12:13:14 -12:00', timestamptz'2033-10-01 12:13:14 Europe/Riga',
        datetimeltz'1823-12-31 23:59:59 +14:00', datetimetz'2099-11-23 12:00:00 AM Australia/Eucla'
);
--when bigint is 123456789, return 'ERROR: Value's precision of 4074074037 exceeds maximum allowed 2147483647'
select REPEAT( c_date, c_bigint ) from t1;
select REPEAT( c_time, c_bigint ) from t1;
select REPEAT( c_timestamp, c_bigint ) from t1;
select REPEAT( c_datetime, c_bigint ) from t1;
select REPEAT( c_timestampltz , c_bigint ) from t1;
select REPEAT( c_timestamptz, c_bigint ) from t1;
select REPEAT( c_datetimeltz, c_bigint ) from t1;
select REPEAT( c_datetimetz, c_bigint ) from t1;

drop table t1;

