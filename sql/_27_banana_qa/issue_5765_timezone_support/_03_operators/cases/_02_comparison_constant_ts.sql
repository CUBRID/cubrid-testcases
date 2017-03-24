--test comparison operators with TIMESTAMP(L)TZ constant values as operands
--+ holdcas on;


--test: test with constant values
set timezone '-8:00';
select if(timestampltz'2014-10-10 13:50:59'=timestampltz'2014-10-10 13:50:59 -8:00', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59'=timestampltz'2014-10-10 13:50:59 America/Metlakatla', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59'=timestampltz'2014-10-10 12:50:59 -9:00', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59 +10:00'=timestampltz'2014-10-10 14:50:59 +11:00', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59 Asia/Seoul'=timestampltz'2014-10-10 13:50:59 Asia/Tokyo', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59 Asia/Seoul'=timestampltz'2014-10-10 13:50:59 +9:00', 'ok', 'nok');

set timezone 'Asia/Ho_Chi_Minh';
select if(timestamptz'2014-10-10 13:50:59'<timestamptz'2014-10-10 13:50:59 +6:00', 'ok', 'nok');
select if(timestamptz'2014-10-10 13:50:59'>timestamptz'2014-10-10 13:50:59 +8:00', 'ok', 'nok');
select if(timestamptz'2014-10-10 13:50:59'>timestamptz'2014-10-10 13:50:59 Asia/Shanghai', 'ok', 'nok');
select if(timestamptz'2014-10-10 13:50:59 +0:00'<=timestamptz'2014-10-10 13:50:59 -2:00', 'ok', 'nok');

--test: constant DST values
set timezone 'Asia/Tehran';
select if(timestampltz'2025-07-01 13:00:00'=timestamptz'2025-07-01 13:00:00 +3:30', 'nok', 'ok');
select if(timestampltz'2025-07-01 13:00:00'<timestamptz'2025-07-01 13:00:00 +3:30', 'ok', 'nok');
select if(timestampltz'2025-09-21 23:00:00 Asia/Tehran +0330'>timestamptz'2025-09-21 23:00:00 Asia/Tehran +0430', 'ok', 'nok');
select if(timestampltz'2025-09-22 00:00:00 Asia/Tehran +0330'!=timestamptz'2025-09-21 23:00:00 Asia/Tehran +0430', 'ok', 'nok');
--test: ambiguous value
select if(timestampltz'2025-09-21 23:00:00'<timestamptz'2025-09-21 23:00:00 +3:30', 'ok', 'nok');
--test: [er] non-existent value
--BUG: CUBRIDSUS-16370, resolved
select timestampltz'2025-03-22 12:00:00 AM';
select timestamptz'2025-09-22 00:00:00 Asia/Tehran +0430';
select if(timestampltz'2025-03-22 12:00:00 AM +3:00'> timestamptz'2025-03-22 01:00:00 AM', 'ok', 'nok');
select if(timestampltz'2025-09-21 23:00:00 Asia/Tehran +0330'>timestamptz'2025-09-21 23:00:00 Asia/Tehran +0430', 'ok', 'nok');

--test: ps
prepare st from 'select if(?=?, ''ok'', ''nok'')';
execute st using timestamptz'2025-07-01 13:00:00', timestamptz'2025-07-01 13:00:00 +4:30';
deallocate prepare st;

prepare st from 'select if(?>?, ''ok'', ''nok'')';
execute st using timestampltz'2025-09-21 23:00:00 Asia/Tehran +0330', timestamptz'2025-09-21 23:00:00 Asia/Tehran +0430';
deallocate prepare st;

prepare st from 'select if(?>=?, ''nok'', ''ok'')';
execute st using timestampltz'2025-03-22 12:00:00 AM +3:00', timestamp'2025-03-22 12:00:00 AM';
deallocate prepare st;


set timezone 'Asia/Seoul';

--+ holdcas off;
