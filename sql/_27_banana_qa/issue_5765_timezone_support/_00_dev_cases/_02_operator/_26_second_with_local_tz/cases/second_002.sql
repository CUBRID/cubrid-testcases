--pass different formats of string arguments

set timezone '+9:00';
--error
select second('8:19:34 AM Asia/Seoul');
select second('1999-11-30 9:10:10 pm Asia/Seoul');
select second('12/12/1644 10:20:55.789 Asia/Seoul');

set timezone 'Asia/Seoul';

