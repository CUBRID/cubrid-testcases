select addtime(timestamp'2007-12-31',timestamp'2007-12-31 23:59:59');
select addtime(timestamp'2007-12-31',timestamptz'2007-12-31 23:59:59');
select addtime(timestamp'2007-12-31',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(timestamp'2007-12-31',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(timestamp'2007-12-31',timestamp'2007-12-31 23:59:59');
select addtime(timestamp'2007-12-31',timestampltz'2007-12-31 23:59:59 +2:00');
select addtime(timestamp'2007-12-31',timestampltz'2007-12-31 23:59:59 +07:00');
select addtime(timestamp'2007-12-31',timestampltz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone 'Asia/Seoul';
select addtime(timestamptz'2007-12-31',timestamp'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31',timestamptz'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(timestamptz'2007-12-31',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(timestamptz'2007-12-31 23:59:59 +02:00',timestamp'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(timestamptz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',timestamp'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59');
select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(timestamptz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


set timezone '+3:59:59';

select addtime(timestampltz'2007-12-31',timestamp'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31',timestampltz'2007-12-31 23:59:59 +2:00');
select addtime(timestampltz'2007-12-31',timestampltz'2007-12-31 23:59:59 +07:00');
select addtime(timestampltz'2007-12-31',timestampltz'2007-12-31 23:59:59 Asia/Shanghai');




select addtime(timestampltz'2007-12-31 23:59:59 +02:00',timestamp'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(timestampltz'2007-12-31 23:59:59 +02:00',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');


select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',timestamp'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59');
select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 +07:00');
select addtime(timestampltz'2007-12-31 23:59:59 America/New_York',timestamptz'2007-12-31 23:59:59 Asia/Shanghai');
