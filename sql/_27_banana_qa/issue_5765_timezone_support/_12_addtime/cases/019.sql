select addtime(datetime'2007-12-31 23:59:59',timestamp'2007-12-31 23:59:59');
select addtime(datetime'2007-12-31 23:59:59',timestamptz'2007-12-31 23:59:59');
select addtime(datetime'2007-12-31 23:59:59',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(datetime'2007-12-31 23:59:59',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(datetime'2007-12-31 23:59:59',timestamp'2007-12-31 23:59:59');
select addtime(datetime'2007-12-31 23:59:59',timestampltz'2007-12-31 23:59:59 +2:00');
select addtime(datetime'2007-12-31 23:59:59',timestampltz'2007-12-31 23:59:59 +07:00');
select addtime(datetime'2007-12-31 23:59:59',timestampltz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone 'Asia/Seoul';
select addtime(datetimetz'2007-12-31 23:59:59',timestamp'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59',timestamptz'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(datetimetz'2007-12-31 23:59:59',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimetz'2007-12-31 23:59:59 +02:00',timestamp'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(datetimetz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',timestamp'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59');
select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(datetimetz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(datetimeltz'2007-12-31 23:59:59',timestamp'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59',timestampltz'2007-12-31 23:59:59 +2:00');
select addtime(datetimeltz'2007-12-31 23:59:59',timestampltz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59',timestampltz'2007-12-31 23:59:59 Asia/Shanghai');




select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',timestamp'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',timestamp'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(datetimeltz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');
