set timezone 'Asia/Seoul';
select datetimetz'1987-5-10 4:30:00';
select datetimetz'1987-5-10 02:30:00';
select datetimetz'1987-5-10 02:00:00';


select to_datetime_tz(addtime(datetime'1987-5-10',time'4:30:00'));
select to_datetime_tz(adddate(datetime '1987-5-10',interval '4:30:00' hour_second));
select to_datetime_tz(adddate(datetime '1987-5-10 02:30:00',interval '2:30:00' hour_second));
select to_datetime_tz(adddate(datetime '1987-5-10 3:30:00',interval '2:30:00' hour_second)); 



select to_datetime_tz(addtime(datetime'1987-5-10',time'02:30:00')); 
select to_datetime_tz(adddate(datetime '1987-5-10',interval '02:30:00' hour_second));

select to_datetime_tz(adddate(datetime '1987-5-10 02:30:00',interval '00:30:00' hour_second));
select to_datetime_tz(adddate(datetime '1987-5-10 3:30:00',interval '00:30:00' hour_second));


select datetimetz'1987-5-10 4:30:00 Asia/Seoul';
select datetimetz'1987-5-10 2:30:00 Asia/Seoul';
select datetimetz'1987-5-10 02:00:00 Asia/Seoul';

select to_datetime_tz(addtime(datetime'1987-5-10',time'02:30:00'));
select to_datetime_tz(adddate(datetime '1987-5-10',interval '2:30:00' hour_second));
select to_datetime_tz(addtime(datetime'1987-5-10',time'2:30:00'));
select to_datetime_tz(adddate(datetime '1987-5-10',interval '2:30:00' hour_second));


select to_datetime_tz(addtime(datetimeltz'1987-5-10 1:30:00',time'0:30:00'));
select to_datetime_tz(adddate(datetimeltz'1987-5-10 1:30:00',interval '0:30:00' hour_second));
select to_datetime_tz(addtime(datetimetz'1987-5-10 1:30:00',time'2:30:00'));
select to_datetime_tz(adddate(datetimetz '1987-5-10 1:30:00',interval '2:30:00' hour_second));
select to_datetime_tz(addtime(datetimeltz'1987-5-10 1:30:00 Asia/Seoul',time'2:30:00'));
select to_datetime_tz(adddate(datetimeltz'1987-5-10 1:30:00 Asia/Seoul',interval '2:30:00' hour_second));
select to_datetime_tz(addtime(datetimetz'1987-5-10 1:30:00 Asia/Seoul',time'2:30:00'));
select to_datetime_tz(adddate(datetimetz'1987-5-10 1:30:00 Asia/Seoul',interval '00:30:00' hour_second));

 set timezone 'America/New_York'

select to_datetime_tz(addtime(datetimetz'2015-3-8',time'2:30:00'));
select to_datetime_tz(adddate(datetimetz '2015-3-8',interval '2:30:00' hour_second));
select to_datetime_tz(addtime(datetimetz'2015-3-8 America/New_York ',time'2:30:00'));
select to_datetime_tz(adddate(datetimetz '2015-3-8 America/New_York',interval '2:30:00' hour_second));
select to_datetime_tz(addtime(datetimeltz'2015-3-8',time'2:30:00'));
select to_datetime_tz(adddate(datetimeltz '2015-3-8',interval '2:30:00' hour_second));
select to_datetime_tz(addtime(datetimeltz'2015-3-8 America/New_York',time'2:30:00'));
select to_datetime_tz(adddate(datetimeltz '2015-3-8 America/New_York',interval '2:30:00' hour_second));

set timezone 'Asia/Seoul';

