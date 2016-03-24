select cast('1970-1-1 2:00:00 -3:00' as timestamptz); 
select cast('1970-1-1 2:00:00 +3:00' as timestamptz); 
select cast('2015-11-1 1:00:00 America/New_York EST' as timestamptz);   
select cast('2015-11-1 1:00:00 America/New_York EDT' as timestamptz); 
select cast('2015-11-1 2:00:00 America/New_York EDT' as timestamptz); 
select cast('2015-11-1 2:00:00 America/New_York EST' as timestamptz);

select cast('2015-3-8 2:20:00 America/New_York' as timestamptz);
select cast('2015-3-8 3:20:00 America/New_York' as timestamptz);






set timezone '+03:00';
select cast('1970-1-1 2:00:00' as timestampltz);
set timezone '-03:00';
select cast('1969-12-31 21:00:00' as timestampltz);
select to_timestamp_tz(cast('1969-12-31 21:00:00' as timestampltz));

select cast('2015-11-1 1:00:00 America/New_York EST' as timestamptz);
select cast('2015-11-1 1:00:00 America/New_York EDT' as timestamptz);
select cast('2015-11-1 2:00:00 America/New_York EDT' as timestamptz);
select cast('2015-11-1 2:00:00 America/New_York EST' as timestamptz);

select cast('2015-3-8 2:20:00 America/New_York' as timestamptz);
select cast('2015-3-8 3:20:00 America/New_York' as timestamptz); 


set timezone '-04:00';
select cast('1969-12-31 21:00:00' as timestampltz);
select to_timestamp_tz(cast('1969-12-31 21:00:00' as timestampltz));

set timezone '-3:00';
select cast('1969-12-31 21:00:00' as datetimeltz);
select to_datetime_tz(cast('1969-12-31 21:00:00' as datetimeltz));

set timezone '-3';
select cast('1969-12-31 21:00:00' as timestampltz);
select to_timestamp_tz(cast('1969-12-31 21:00:00' as timestampltz));

select cast('1969-12-31 21:00:00' as datetimeltz);
select to_datetime_tz(cast('1969-12-31 21:00:00' as datetimeltz));

set timezone '-3';
select cast('1969-12-31 21:00:01' as timestampltz);
select to_timestamp_tz(cast('1969-12-31 21:00:01' as timestampltz));

select cast('1969-12-31 21:00:01' as datetimeltz);
select to_datetime_tz(cast('1969-12-31 21:00:01' as datetimeltz));

set timezone '-3';
select cast('0000-00-00 00:00:00' as datetimeltz);
select to_datetime_tz(cast('0000-00-00 00:00:00' as datetimeltz));

