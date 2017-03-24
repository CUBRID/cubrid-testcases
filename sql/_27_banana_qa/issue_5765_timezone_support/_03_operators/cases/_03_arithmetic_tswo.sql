--use TIMESTAMP column as arithmetic operands
--+ holdcas on;
set system parameters 'tz_leap_second_support=yes';

drop table if exists tz_test;

create table tz_test (id int, ts timestamp);

--test: ts +/- numeric
set timezone '-8:00';
insert into tz_test values(1, '2014-10-10 13:50:59');
select if(ts+1=timestampltz'2014-10-10 13:51:00 -8:00', 'ok', 'nok') from tz_test where id=1;
select if(ts-1=timestampltz'2014-10-10 13:50:58 America/Metlakatla', 'ok', 'nok') from tz_test where id=1;
select if(ts+3600=timestampltz'2014-10-10 13:50:59 -9:00', 'ok', 'nok') from tz_test where id=1;
insert into tz_test values(2, '2014-10-10 13:50:59 +10:00');
select if(ts-7200=timestampltz'2014-10-11 8:50:59 +13:00', 'ok', 'nok') from tz_test where id=2;
set timezone 'Asia/Seoul';
insert into tz_test values(3, '2014-10-10 13:50:59');
select if(ts+3600=timestampltz'2014-10-10 13:50:59 Asia/Chongqing', 'ok', 'nok') from tz_test where id=3;
select if(ts-3600=timestampltz'2014-10-10 13:50:59 +10:00', 'ok', 'nok') from tz_test where id=3;
--test: ps
prepare st from 'select if(ts-?=?, ''ok'', ''nok'') from tz_test where id=3';
execute st using 3600, timestampltz'2014-10-10 13:50:59 +10:00';
deallocate prepare st;

--test: ts - ts
set timezone 'Asia/Ho_Chi_Minh'; 
-- +7:00
insert into tz_test values(4, '2014-10-10 13:50:59');
select if(ts-timestampltz'2014-10-10 13:50:59 +6:00'=-3600, 'ok', 'nok') from tz_test where id=4;
select if(ts-timestampltz'2014-10-10 13:50:59 +8:00'=3600, 'ok', 'nok') from tz_test where id=4;
select if(ts-timestampltz'2014-10-10 13:50:59 Asia/Shanghai'=3600, 'ok', 'nok') from tz_test where id=4;
insert into tz_test values(5, timestamptz'2014-10-10 13:50:59 +0:00');
select if(ts-timestampltz'2014-10-10 13:50:59 -2:00'=-7200, 'ok', 'nok') from tz_test where id=5;
--test: [er] ts + ts
select ts+timestampltz'2014-10-10 13:50:59 -2:00' from tz_test where id=5;
--test: ps
prepare st from 'select if(ts-?=?, ''ok'', ''nok'') from tz_test tz_test where id=?';
execute st using timestampltz'2014-10-10 13:50:59 -2:00', -7200, 5;
deallocate prepare st;

--test: DST values
set timezone 'Asia/Tehran';
-- +3:30
insert into tz_test values(6, '2025-07-01 13:00:00');
select if(ts+3600=timestampltz'2025-07-01 13:00:00 +3:30', 'ok', 'nok') from tz_test where id=6;
select if(ts-timestampltz'2025-07-01 13:00:00 +3:30'=-3600, 'ok', 'nok') from tz_test where id=6;
insert into tz_test values(7, timestampltz'2025-09-21 23:00:00 Asia/Tehran +0330');
select if(ts-timestampltz'2025-09-21 23:00:00 Asia/Tehran +0430'=3600, 'ok', 'nok') from tz_test where id=7;
select if(timestampltz'2025-09-21 23:59:59 Asia/Tehran +0430'+1=ts, 'ok', 'nok') from tz_test where id=7;
--test: [er] ambiguous value
insert into tz_test values(8, '2025-09-21 22:59:59');
select ts+3601 from tz_test where id=8;
--test: [er] non-existent value
insert into tz_test values(9, timestampltz'2025-03-22 12:00:00 AM +3:30');
select if(ts=timestampltz'2025-03-22 1:00:00', 'ok', 'nok') from tz_test where id=9;
insert into tz_test values(10, '2025-03-21 23:59:59');
select if(ts+1=timestampltz'2025-03-22 1:00:00', 'ok', 'nok') from tz_test where id=10;
insert into tz_test values(11, '2025-03-22 12:00:01 AM');
select * from tz_test where id=11;
insert into tz_test values(12, '2025-03-22 1:00:00 AM');
select if(ts-1=timestampltz'2025-03-21 23:59:59', 'ok', 'nok') from tz_test where id=12;
--test: ps
prepare st from 'select if(ts-?=?, ''ok'', ''nok'') from tz_test where id=12';
execute st using 1, timestampltz'2025-03-21 23:59:59';
deallocate prepare st;

--test: leap seconds
insert into tz_test values(13, timestampltz'2012-06-30 23:59:59 UTC');
select if(ts+1>timestamptz'2012-06-30 23:59:59 UTC', 'ok', 'nok') from tz_test where id=13; 
select if(ts-timestampltz'2012-06-30 23:59:59 UTC'=0, 'ok', 'nok') from tz_test where id=13;
select if(ts+2=timestampltz'2012-07-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=13; 
insert into tz_test values(14, '2012-07-01 4:29:59');
select if(ts+1>timestampltz'2012-07-01 4:29:59', 'ok', 'nok') from tz_test where id=14;
select if(ts+2=timestampltz'2012-07-01 4:30:00', 'ok', 'nok') from tz_test where id=14;
insert into tz_test values(15, timestamptz'2012-07-01 12:00:00 AM UTC');
select if(ts-timestampltz'2012-06-30 23:59:59 UTC'=2, 'ok', 'nok') from tz_test where id=15;
insert into tz_test values(16, '2012-07-01 4:30:00');
select if(ts-timestampltz'2012-07-01 4:29:59'=2, 'ok', 'nok') from tz_test where id=16;
--test: ps
prepare st from 'select if(ts+?=?, ''ok'', ''nok'') from tz_test where id=?';
execute st using 2, timestampltz'2012-07-01 4:30:00', 14;
deallocate prepare st;


drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';

--+ holdcas off;
