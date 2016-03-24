select addtime(date'2007-12-31',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(date'2007-12-31',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(date'2007-12-31',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone 'Asia/Seoul';
select addtime(date'2007-12-31',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(date'2007-12-31',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(date'2007-12-31 ',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31 ',datetimetz'2007-12-31 23:59:59');
select addtime(date'2007-12-31 ',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31 ',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(date'2007-12-31',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimeltz'2007-12-31 23:59:59 +2:00');
select addtime(date'2007-12-31',datetimeltz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31',datetimeltz'2007-12-31 23:59:59 Asia/Shanghai');




select addtime(date'2007-12-31',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(date'2007-12-31 ',datetime'2007-12-31 23:59:59');
select addtime(date'2007-12-31 ',datetimetz'2007-12-31 23:59:59');
select addtime(date'2007-12-31 ',datetimetz'2007-12-31 23:59:59 +07:00');
select addtime(date'2007-12-31 ',datetimetz'2007-12-31 23:59:59 Asia/Shanghai');
