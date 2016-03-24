--+ holdcas on;
set timezone '+09:00';
 select from_unixtime(3600);
set timezone '+08:00';
 select from_unixtime(3600);

set timezone 'Asia/Seoul';
select from_unixtime(3600);
set timezone 'Asia/Shanghai';
select from_unixtime(3600);


set timezone 'America/New_York'
select from_unixtime(3600);
set timezone 'Asia/Seoul';
--+ holdcas off;
