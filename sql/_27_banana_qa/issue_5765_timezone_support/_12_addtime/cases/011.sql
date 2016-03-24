--timestampltz  +  timeltz
set timezone '+09:00';
select addtime(timestampltz'2000-1-1 ',time'13:00:00');
select to_datetime_tz(addtime(timestampltz'2000-1-1 ' ,time'13:00:00'));

set timezone '-4:00';
select addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00');
select to_datetime_tz(addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00'));

select to_datetime_tz(addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'1:30:00')); 
select to_datetime_tz(addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'3:30:00'));




set timezone '+09:00';
select addtime(timestampltz'2000-1-1 ',time'13:00:00');
select to_datetime_tz(addtime(timestampltz'2000-1-1 ' ,time'13:00:00'));

set timezone '+00:00';
select addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00');
select to_datetime_tz(addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'2:30:00'));

select to_datetime_tz(addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'1:30:00'));
select to_datetime_tz(addtime(timestampltz'2015-3-8 00:00:00 America/New_York ' ,time'3:30:00')); 




