--compare TIMESTAMPTZ column with constant values

drop table if exists tz_test;

create table tz_test(id int, ts timestamp with time zone);

set timezone '-8:00';
insert into tz_test values(1, timestamptz'2014-10-10 13:50:59');
insert into tz_test values(2, timestamptz'2014-10-10 13:50:59 +10:00');
insert into tz_test values(3, timestamptz'2014-10-10 13:50:59 Asia/Seoul');

--test: test with constant values
select if(ts=timestamptz'2014-10-10 13:50:59 -8:00', 'ok', 'nok') from tz_test where id=1;
select if(ts=timestamptz'2014-10-10 13:50:59 America/Metlakatla', 'ok', 'nok') from tz_test where id=1;
select if(ts=timestamptz'2014-10-10 12:50:59 -9:00', 'ok', 'nok') from tz_test where id=1;
select if(ts=timestamptz'2014-10-10 14:50:59 +11:00', 'ok', 'nok') from tz_test where id=2;
select if(ts=timestamptz'2014-10-10 13:50:59 Asia/Tokyo', 'ok', 'nok') from tz_test where id=3;
select if(ts=timestamptz'2014-10-10 13:50:59 +9:00', 'ok', 'nok') from tz_test where id=3;

set timezone 'Asia/Ho_Chi_Minh';
insert into tz_test values(4, '2014-10-10 13:50:59');
insert into tz_test values(5, '2014-10-10 13:50:59 +0:00');
select if(ts<timestamptz'2014-10-10 13:50:59 +6:00', 'ok', 'nok') from tz_test where id=4;
select if(ts>timestamptz'2014-10-10 13:50:59 +8:00', 'ok', 'nok') from tz_test where id=4;
select if(ts>timestamptz'2014-10-10 13:50:59 Asia/Shanghai', 'ok', 'nok') from tz_test where id=4;
select if(ts<=timestamptz'2014-10-10 13:50:59 -1:00', 'ok', 'nok') from tz_test where id>2;

--test: constant DST values
set timezone 'Asia/Tehran';
insert into tz_test values(6, '2025-07-01 13:00:00');
select if(ts=timestamptz'2025-07-01 13:00:00 +3:30', 'nok', 'ok') from tz_test where id=6;
select if(ts<timestamptz'2025-07-01 13:00:00 +3:30', 'ok', 'nok') from tz_test where id=6;
--test: ?? ambiguous value
insert into tz_test values(7, '2025-09-21 23:00:00 Asia/Tehran +0330');
select if(ts>timestamptz'2025-09-21 23:00:00 Asia/Tehran +0430', 'ok', 'nok') from tz_test where id=7;
insert into tz_test values(8, '2025-09-22 00:00:00 Asia/Tehran +0330');
select if(ts!=timestamptz'2025-09-21 23:00:00 Asia/Tehran +0430', 'ok', 'nok') from tz_test where id=8;
--test: ambiguous value
insert into tz_test values(9, '2025-09-21 23:00:00');
select if(ts<timestamptz'2025-09-21 23:00:00 +3:30', 'ok', 'nok') from tz_test where id=9;
--test: [er] non-existent value
insert into tz_test values(10, '2025-03-22 12:00:00 AM');
select if(timestamptz'2025-03-22 12:00:00 AM +3:00'>=ts, 'nok', 'ok') from tz_test where id=10;
insert into tz_test values(11, '2025-09-21 23:00:00 Asia/Tehran +0330');
select if(ts>timestamptz'2025-09-22 00:00:00 Asia/Tehran +0430', 'nok', 'ok') from tz_test where id=11;


drop table tz_test; 

set timezone 'Asia/Seoul';
