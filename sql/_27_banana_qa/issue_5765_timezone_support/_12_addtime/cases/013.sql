--datetimeltz  +  time
set timezone '+09:00';
select addtime(datetimeltz'2000-1-1 ',time'13:00:00');
select to_datetime_tz(addtime(datetimeltz'2000-1-1 ' ,time'13:00:00'));

set timezone '-4:00';
select addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00');
select to_datetime_tz(addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00'));

select to_datetime_tz(addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'1:30:00')); 
select to_datetime_tz(addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'3:30:00'));




set timezone '+09:00';
select addtime(datetimeltz'2000-1-1 ',time'13:00:00');
select to_datetime_tz(addtime(datetimeltz'2000-1-1 ' ,time'13:00:00'));

set timezone '+00:00';
select addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00');
select to_datetime_tz(addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00'));

select to_datetime_tz(addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'1:30:00'));
select to_datetime_tz(addtime(datetimeltz'2015-3-8 00:00:00 America/New_York ' ,time'3:30:00')); 

set timezone 'America/New_York';
select to_datetime_tz(new_time(datetime'2015-3-8 01:35:00', '-5:00', 'America/New_York'));
select to_datetime_tz(new_time(datetime'2015-3-8 02:35:00', '-4:00', 'America/New_York')); 

