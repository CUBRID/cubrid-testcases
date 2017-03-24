--use DATETIME column as arithmetic operands
--+ holdcas on;

drop table if exists tz_test;

create table tz_test (id int, dt datetime);

--test: dt +/- numeric
set timezone '-8:00';
insert into tz_test values(1, '2014-10-10 13:50:59.999');
select if(dt+1000=datetimeltz'2014-10-10 13:51:00.999 -8:00', 'ok', 'nok') from tz_test where id=1;
select if(dt-1000=datetimeltz'2014-10-10 13:50:58.999 America/Metlakatla', 'ok', 'nok') from tz_test where id=1;
select if(dt+3600*1000=datetimeltz'2014-10-10 13:50:59.999 -9:00', 'ok', 'nok') from tz_test where id=1;
insert into tz_test values(2, datetimeltz'2014-10-10 13:50:59.999 +10:00');
select if(dt-7200*1000=datetimeltz'2014-10-10 14:50:59.999 +13:00', 'ok', 'nok') from tz_test where id=2;
set timezone 'Asia/Seoul';
insert into tz_test values(3, '2014-10-10 13:50:59.999');
select if(dt+3600*1000=datetimeltz'2014-10-10 13:50:59.999 Asia/Chongqing', 'ok', 'nok') from tz_test where id=3;
select if(dt-3600*1000=datetimeltz'2014-10-10 13:50:59.999 +10:00', 'ok', 'nok') from tz_test where id=3;
--test: ps
prepare st from 'select if(dt-?=?, ''ok'', ''nok'') from tz_test where id=3';
execute st using 3600000, datetimeltz'2014-10-10 13:50:59.999 +10:00';
deallocate prepare st;

--test: dt - dt
set timezone 'Asia/Ho_Chi_Minh'; 
-- +7:00
insert into tz_test values(4, '2014-10-10 13:50:59.999');
select if(dt-datetimeltz'2014-10-10 13:50:59.999 +6:00'=-3600*1000, 'ok', 'nok') from tz_test where id=4;
select if(dt-datetimeltz'2014-10-10 13:50:59.999 +8:00'=3600*1000, 'ok', 'nok') from tz_test where id=4;
select if(dt-datetimeltz'2014-10-10 13:50:59.999 Asia/Shanghai'=3600*1000, 'ok', 'nok') from tz_test where id=4;
insert into tz_test values(5, datetimeltz'2014-10-10 13:50:59.999 +0:00');
select if(dt-datetimeltz'2014-10-10 13:50:59.999 -2:00'=-7200*1000, 'ok', 'nok') from tz_test where id=5;
--test: [er] dt + dt
select dt+datetimeltz'2014-10-10 13:50:59.999 -2:00' from tz_test where id=5;
--test: ps
prepare st from 'select if(dt-?=?, ''ok'', ''nok'') from tz_test tz_test where id=?';
execute st using datetimeltz'2014-10-10 13:50:59.999 -2:00', -7200000, 5;
deallocate prepare st;

--test: DST values
set timezone 'Asia/Tehran';
-- +3:30
insert into tz_test values(6, datetimeltz'2025-07-01 13:00:00.999');
select if(dt+3600*1000=datetimeltz'2025-07-01 13:00:00.999 +3:30', 'ok', 'nok') from tz_test where id=6;
select if(dt-datetimeltz'2025-07-01 13:00:00.999 +3:30'=-3600*1000, 'ok', 'nok') from tz_test where id=6;
insert into tz_test values(7, datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0330');
select if(dt-datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0430'=0, 'ok', 'nok') from tz_test where id=7;
select if(datetimeltz'2025-09-21 23:59:59.999 Asia/Tehran +0430'+1000-3600*1000=dt, 'ok', 'nok') from tz_test where id=7;
--test: [er] ambiguous value
insert into tz_test values(8, datetimeltz'2025-09-21 22:59:59.999');
select dt+3601*1000 from tz_test where id=8;
--test: [er] non-existent value
insert into tz_test values(9, datetimeltz'2025-03-22 12:00:00.999 AM +3:30');
select if(dt=datetimeltz'2025-03-22 1:00:00.999', 'ok', 'nok') from tz_test where id=9;
insert into tz_test values(10, datetimeltz'2025-03-21 23:59:59.999');
select if(dt+1000=datetimeltz'2025-03-22 1:00:00.999', 'ok', 'nok') from tz_test where id=10;
insert into tz_test values(11, datetimeltz'2025-03-22 12:00:01.999 AM');
select * from tz_test where id=11;
insert into tz_test values(12, datetimeltz'2025-03-22 1:00:00.999 AM');
select if(dt-1000=datetimeltz'2025-03-21 23:59:59.999', 'ok', 'nok') from tz_test where id=12;
--test: ps
prepare st from 'select if(dt-?=?, ''ok'', ''nok'') from tz_test where id=12';
execute st using 1000, datetimeltz'2025-03-21 23:59:59.999';
deallocate prepare st;

--test: leap seconds
insert into tz_test values(13, datetimeltz'2012-06-30 23:59:59.999 UTC');
select if(dt+2000=datetimeltz'2012-07-01 12:00:01.999 AM UTC', 'ok', 'nok') from tz_test where id=13; 
insert into tz_test values(14, '2012-07-01 4:29:59.999');
select if(dt+1000=datetimeltz'2012-07-01 4:30:00.999', 'ok', 'nok') from tz_test where id=14;
insert into tz_test values(15, datetimeltz'2012-07-01 12:00:00.999 AM UTC');
select if(dt-datetimeltz'2012-06-30 23:59:59.999 UTC'=1000, 'ok', 'nok') from tz_test where id=15;
insert into tz_test values(16, '2012-07-01 4:30:00.999');
select if(dt-datetimeltz'2012-07-01 4:29:59.999'=1000, 'ok', 'nok') from tz_test where id=16;
--test: ps
prepare st from 'select if(dt+?=?, ''ok'', ''nok'') from tz_test where id=?';
execute st using 1000, datetimeltz'2012-07-01 4:30:00.999', 14;
deallocate prepare st;


drop table tz_test;

set timezone 'Asia/Seoul';

--+ holdcas off;
