set timezone 'Asia/Seoul';
select addtime(datetimetz'1987-5-10 1:30:00',time '0:30:00');
select adddate(datetimetz'1987-5-10 1:30:00',interval '0:30:00' hour_second);

set timezone 'America/New_York';
select addtime(datetimetz'2015-3-8 01:59:59',time'0:00:01');
select addtime(datetimetz'2015-3-8 01:59:59',time'0:00:01');
select addtime(datetimetz'2015-3-8 01:59:59',time'0:00:01');

select addtime(timestamptz'2015-3-8 01:59:59',time'0:00:01');
select addtime(timestamptz'2015-3-8 01:59:59',time'0:00:01');
select addtime(timestamptz'2015-3-8 01:59:59',time'0:00:01');


select addtime(datetimeltz'2015-3-8 01:59:59',time'0:00:01');
select addtime(datetimeltz'2015-3-8 01:59:59',time'0:00:01');
select addtime(datetimeltz'2015-3-8 01:59:59',time'0:00:01');

select addtime(timestampltz'2015-3-8 01:59:59',time'0:00:01');
select addtime(timestampltz'2015-3-8 01:59:59',time'0:00:01');
select addtime(timestampltz'2015-3-8 01:59:59',time'0:00:01');


select addtime(timestamptz'2015-3-8 01:59:59 -5',time'0:00:01');
select addtime(timestamptz'2015-3-8 01:59:59 -5',time'0:00:01');
select addtime(timestamptz'2015-3-8 01:59:59 -5',time'0:00:01');

select addtime(datetimetz'2015-3-8 01:59:59 -5',time'0:00:01');
select addtime(datetimetz'2015-3-8 01:59:59 -5',time'0:00:01');
select addtime(datetimetz'2015-3-8 01:59:59 -5',time'0:00:01');


select addtime(timestampltz'2015-3-8 01:59:59 -4',time'1:00:01');
select addtime(timestampltz'2015-3-8 01:59:59 -4',time'1:00:01');
select addtime(timestampltz'2015-3-8 01:59:59 -4',time'1:00:01');

select addtime(datetimeltz'2015-3-8 01:59:59 -4',time'1:00:01');
select addtime(datetimeltz'2015-3-8 01:59:59 -4',time'1:00:01');
select addtime(datetimeltz'2015-3-8 01:59:59 -4',time'1:00:01');


select addtime(datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 0:00:00 -00:01');
select addtime(datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 0:00:00 -5');

select addtime(timestamptz'2015-3-8 01:59:59',datetimetz'2015-9-17 0:00:00 -00:01');
select addtime(timestamptz'2015-3-8 01:59:59',datetimetz'2015-9-17 0:00:00 -5');

select addtime(timestamptz'2015-3-8 01:59:59',datetimeltz'2015-9-17 0:00:00 -5');
select addtime(timestamptz'2015-3-8 01:59:59',datetimeltz'2015-9-17 0:00:00 -00:01');

set timezone 'Asia/Seoul';
