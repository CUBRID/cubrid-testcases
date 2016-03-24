set timezone '+09:00';
select extract(hour from datetimeltz '2015-8-11 10:29:02 +08:00');
select extract(minute from datetimeltz '2015-8-11 10:29:02 +08:00');
select extract(second from datetimeltz '2015-8-11 10:29:02.999 +08:00');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999 +08:00');


select extract(hour from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(minute from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(second from datetimeltz '2015-8-11 10:29:02.999 Asia/Shanghai');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999 Asia/Shanghai');


set timezone '+02:00';
select extract(hour from datetimeltz '2015-8-11 10:29:02 +08:00');
select extract(minute from datetimeltz '2015-8-11 10:29:02 +08:00');
select extract(second from datetimeltz '2015-8-11 10:29:02.999 +08:00');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999 +08:00');


select extract(hour from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(minute from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(second from datetimeltz '2015-8-11 10:29:02.999 Asia/Shanghai');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999 Asia/Shanghai');



set timezone 'America/New_York';
select if(extract(hour from datetimeltz '2015-8-11 10:29:02 +08:00')=22 or extract(hour from datetimeltz '2015-8-11 10:29:02 +08:00')=21,'ok','nok');
select extract(minute from datetimeltz '2015-8-11 10:29:02 +08:00');
select extract(second from datetimeltz '2015-8-11 10:29:02.999 +08:00');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999 +08:00');


select if(extract(hour from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai')=22 or extract(hour from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai')=21,'ok','nok');
select extract(minute from datetimeltz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(second from datetimeltz '2015-8-11 10:29:02.999 Asia/Shanghai');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999 Asia/Shanghai');

set timezone 'Asia/Seoul';
select extract(hour from datetimeltz '2015-8-11 10:29:02');
select extract(minute from datetimeltz '2015-8-11 10:29:02');
select extract(second from datetimeltz '2015-8-11 10:29:02.999');
select extract(millisecond from datetimeltz '2015-8-11 10:29:02.999');
set timezone 'Asia/Seoul';

