select extract(hour from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(minute from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(second from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(millisecond from timestamptz '2015-8-11 10:29:02.999 +08:00');


select extract(hour from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(minute from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(second from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(millisecond from timestamptz '2015-8-11 10:29:02.999 Asia/Shanghai');


set timezone '+02:00';
select extract(hour from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(minute from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(second from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(millisecond from timestamptz '2015-8-11 10:29:02.999 +08:00');


select extract(hour from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(minute from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(second from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(millisecond from timestamptz '2015-8-11 10:29:02.999 Asia/Shanghai');



set timezone 'America/New_York';
select extract(hour from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(minute from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(second from timestamptz '2015-8-11 10:29:02 +08:00');
select extract(millisecond from timestamptz '2015-8-11 10:29:02.999 +08:00');


select extract(hour from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(minute from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(second from timestamptz '2015-8-11 10:29:02 Asia/Shanghai');
select extract(millisecond from timestamptz '2015-8-11 10:29:02.999 Asia/Shanghai');

set timezone 'Asia/Seoul';


