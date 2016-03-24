set timezone 'Asia/Seoul';
SELECT ADDTIME(timestamp'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(timestamptz'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(timestampltz'2007-12-31 23:59:59', time'1:1:2');


set timezone '+09:00';
SELECT ADDTIME(timestamp'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(timestamptz'2007-12-31 23:59:59', time'1:1:2');
SELECT ADDTIME(timestamptz'2007-12-31 23:59:59 America/New_York', time'1:1:2');
SELECT ADDTIME(timestamptz'2007-12-31 23:59:59 Asia/Shanghai', time'1:1:2');
SELECT ADDTIME(timestamptz'2007-12-31 23:59:59 Asia/Shanghai', time'1:1:2');


SELECT ADDTIME(timestampltz'2007-12-31 23:59:59', time'1:1:2');

SELECT ADDTIME(timestampltz'2007-12-31 23:59:59 +08:00', time'1:1:2');




