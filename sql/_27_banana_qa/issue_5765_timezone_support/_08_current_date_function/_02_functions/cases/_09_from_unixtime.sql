--+ holdcas on;
set timezone '+09:00';
 select from_unixtime(1437642174,'%y%m%d %H%i%S');
set timezone '+08:00';
 select from_unixtime(1437642174,'%y%m%d %H%i%S');

set timezone 'Asia/Seoul';
select from_unixtime(1437642174,'%y%m%d %H%i%S');
set timezone 'Asia/Shanghai';
select from_unixtime(1437642174,'%y%m%d %H%i%S');
set timezone 'Asia/Seoul';

--need to think of summer time
--set timezone 'America/New_York';
--select from_unixtime(1437642174,'%y%m%d %H%i%S');
--+ holdcas off;
