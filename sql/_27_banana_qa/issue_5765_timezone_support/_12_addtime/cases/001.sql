--args[0]: timestamp
--args[1]: datetimeltz/datetimetz
set timezone 'Asia/Seoul';
select addtime(timestamp'2000-1-1 13:00:00',datetimeltz'2000-1-1 1:00:00 +07:00');
select addtime(timestamp'2000-1-1 13:00:00',datetimeltz'2000-1-1 1:00:00 +09:00'); 



set timezone 'Asia/Seoul';
select addtime(timestamp'2000-1-1 13:00:00',datetimetz'2000-1-1 1:00:00 +07:00');
select addtime(timestamp'2000-1-1 13:00:00',datetimetz'2000-1-1 1:00:00 +09:00');



--args[0]: timestamptz
--args[1]: datetimeltz/datetimetz
select addtime(timestamptz'2000-1-1 13:00:00 Asia/Shanghai',datetimetz'2000-1-1 1:00:00 +07:00');
select addtime(timestamptz'2000-1-1 13:00:00 +08:00',datetimetz'2000-1-1 1:00:00 +09:00');



select addtime(timestamptz'2000-1-1 13:00:00 +07:00',datetimeltz'2000-1-1 1:00:00 +07:00');
select addtime(timestamptz'2000-1-1 13:00:00 +07:00',datetimeltz'2000-1-1 1:00:00 +09:00');

