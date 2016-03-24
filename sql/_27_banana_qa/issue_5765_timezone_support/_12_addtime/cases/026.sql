set timezone 'America/New_York';
select addtime(datetimetz'2015-3-8 1:00:00',time'3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestamp'1970-1-2 3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestamptz'1970-1-2 3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestampltz'1970-1-2 3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',datetime'3:00:00');

select adddate(datetimetz'2015-3-8 1:00:00',interval '3:00:00' hour_second);


select addtime(datetimetz'2015-11-1 1:00:00',time'1:00:00');
select adddate(datetimetz'2015-11-1 1:00:00',interval '1:00:00' hour_second);  

select addtime(datetimetz'2015-11-1 1:00:00',datetimetz'1970-1-1 1:00:00');
select addtime(datetimetz'2015-11-1 1:00:00',datetimeltz'1970-1-1 1:00:00');
select addtime(datetimetz'2015-11-1 1:00:00',timestamptz'1970-1-1 1:00:00');
select addtime(datetimetz'2015-11-1 1:00:00',timestampltz'1970-1-1 1:00:00');

select addtime(timestamptz '1969-12-31 19:00:01 America/New_York',time'00:00:01'); 
select to_timestamp_tz('1970-1-1 00:00:01 +02:00'); 
select to_timestamp_tz('1970-1-1 09:00:01 +02:00'); 

set timezone 'Asia/Seoul';

select addtime(datetimetz'2015-3-8 1:00:00',time'3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestamp'1970-1-2 3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestamptz'1970-1-2 3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestampltz'1970-1-2 3:00:00');

select addtime(datetimetz'2015-3-8 1:00:00',timestamp'1970-1-2 3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestamptz'1970-1-2 3:00:00 +07:00');
select addtime(datetimetz'2015-3-8 1:00:00',timestampltz'1970-1-2 3:00:00 +07:00');

select addtime(datetimetz'2015-3-8 1:00:00',datetime'3:00:00');
select addtime(datetimetz'2015-3-8 1:00:00',datetime'1970-1-1 3:00:00');

select adddate(datetimetz'2015-3-8 1:00:00',interval '3:00:00' hour_second);


select addtime(datetimetz'2015-11-1 1:00:00',time'1:00:00');
select adddate(datetimetz'2015-11-1 1:00:00',interval '1:00:00' hour_second);

select addtime(datetimetz'2015-11-1 1:00:00',datetimetz'1970-1-1 1:00:00');
select addtime(datetimetz'2015-11-1 1:00:00',datetimeltz'1970-1-1 1:00:00');
select addtime(datetimetz'2015-11-1 1:00:00',datetimeltz'1970-1-1 1:00:00 -1:00');
select addtime(datetimetz'2015-11-1 1:00:00',datetimeltz'1970-1-1 1:00:00 -12:00');
select addtime(datetimetz'2015-11-1 1:00:00',datetimeltz'1970-1-1 2:00:00 -12:00');
 select addtime(datetimetz'2015-11-1 1:00:00',datetimetz'1970-1-1 2:00:00 -12:00'); 

select addtime(datetimetz'2015-11-1 1:00:00',timestamptz'1970-1-1 1:00:00');
select addtime(datetimetz'2015-11-1 1:00:00',timestampltz'1970-1-1 1:00:00');

select addtime(timestamptz '1969-12-31 19:00:01 America/New_York',time'00:00:01');
select to_timestamp_tz('1970-1-1 00:00:01 +02:00');
select to_timestamp_tz('1970-1-1 09:00:01 +02:00');
