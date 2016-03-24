set timezone 'Asia/Seoul';
SELECT ADDTIME(datetime'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(datetimetz'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(datetimeltz'2007-12-31 23:59:59', time'1:1:2');


set timezone '+09:00';
SELECT ADDTIME(datetime'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(datetimetz'2007-12-31 23:59:59', time'1:1:2');
SELECT ADDTIME(datetimetz'2007-12-31 23:59:59 America/New_York', time'1:1:2');
SELECT ADDTIME(datetimetz'2007-12-31 23:59:59 Asia/Shanghai', time'1:1:2');
SELECT ADDTIME(datetimetz'2007-12-31 23:59:59 Asia/Shanghai', time'1:1:2');


SELECT ADDTIME(datetimeltz'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(datetimeltz'2007-12-31 23:59:59 +08:00', time'1:1:2');


