select addtime(datetime'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(datetime'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59');
select addtime(datetime'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetime'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(datetime'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(datetime'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(datetime'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(datetime'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone 'Asia/Seoul';
select addtime(datetimetz'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimetz'2007-12-31 23:59:59',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimetz'2007-12-31 23:59:59 +02:00',datetime'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimetz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',datetime'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(datetimeltz'2007-12-31 23:59:59',datetime'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(datetimeltz'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');




select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetime'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetime'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(datetimeltz'2007-12-31 23:59:59 +2:00',datetime'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 Asia/Shanghai',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(datetimeltz'2007-12-31 23:59:59 +8:00',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 -1:59:59',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');




select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetime'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetime'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');
