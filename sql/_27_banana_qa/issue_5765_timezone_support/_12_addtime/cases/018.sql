select addtime(timestamp'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(timestamp'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59');
select addtime(timestamp'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(timestamp'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(timestamp'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(timestamp'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(timestamp'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(timestamp'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone 'Asia/Seoul';
select addtime(timestamptz'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(timestamptz'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(timestamptz'2007-12-31 23:59:59 +02:00',datetime'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(timestamptz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',datetime'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(timestampltz'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(timestampltz'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(timestampltz'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');




select addtime(timestampltz'2007-12-31 23:59:59 +02:00',datetime'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(timestampltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',datetime'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');
