--timestamptz  +  timeltz
set timezone '+09:00';
select addtime(timestamptz'2000-1-1 ',time'13:00:00');
select to_datetime_tz(addtime(timestamptz'2000-1-1 ' ,time'13:00:00'));

set timezone '-4:00';
select addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00');
select to_datetime_tz(addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00'));

select to_datetime_tz(addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'1:30:00')); 
select to_datetime_tz(addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'3:30:00'));




set timezone '+09:00';
select addtime(timestamptz'2000-1-1 ',time'13:00:00');
select to_datetime_tz(addtime(timestamptz'2000-1-1 ' ,time'13:00:00'));

set timezone '+00:00';
select addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00');
select to_datetime_tz(addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00'));

select to_datetime_tz(addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'1:30:00'));
select to_datetime_tz(addtime(timestamptz'2015-3-8 00:00:00 America/New_York ' ,time'3:30:00')); 




