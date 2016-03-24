set timezone 'Asia/Seoul';

select addtime('2015-01-01 1:00:00 AM +9:00',time'13:59:1');
select addtime('2015-01-01 1:00:00.123 PM -1:00',time'13:59:1');

select addtime('2015-01-01 1:00:00 AM Asia/Seoul',time'13:59:1');
select addtime('2015-01-01 1:00:00 AM Asia/Seoul','2015-1-1 13:59:1');

set timezone '+8:00';

select addtime('2015-01-01 1:00:00 AM +9:00',time'13:59:1');
select addtime('2015-01-01 1:00:00.123 PM -1:00',time'13:59:1');

select addtime('2015-01-01 1:00:00 AM Asia/Seoul',time'13:59:1');
select addtime('2015-01-01 1:00:00.9 AM Asia/Chongqing',time'13:59:1');

select addtime('2015-01-01 1:00:00 AM Asia/Seoul','2015-1-1 13:59:1');

set timezone 'Asia/Seoul';
