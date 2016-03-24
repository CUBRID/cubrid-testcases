set timezone '-04:00';
select addtime(time'1:00:00',time'1:1:1');

set timezone 'Asia/Shanghai';
select to_datetime_tz(concat(addtime('2015-3-8 00:20:00' ,'2:30:00'),'Asia/Seoul'));
select to_datetime_tz(concat(addtime('2015-3-8 00:20:00' ,'2:30:00'),'+02')); 
select addtime(datetimetz'2015-11-1 1:00:00 ',timestamptz'1970-1-1 1:00:00 +00');
select addtime(datetimetz'2015-11-1 1:00:00  ',timestampltz'1970-1-1 1:00:00 +00');
select addtime(datetimetz'2015-11-1 1:00:00 +2',timestamptz'1970-1-1 1:00:00 +00');
select addtime(datetimetz'2015-11-1 1:00:00 +2',timestampltz'1970-1-1 1:00:00 +00');

