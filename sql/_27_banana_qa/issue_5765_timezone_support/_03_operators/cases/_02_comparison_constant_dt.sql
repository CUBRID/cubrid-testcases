--test comparison operators with DATETIME(L)TZ constant values as operands
--+ holdcas on;


--test: test with constant values
set timezone '-8:00';
select if(datetimeltz'2014-10-10 13:50:59.999'=datetimeltz'2014-10-10 13:50:59.999 -8:00', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999'=datetimeltz'2014-10-10 13:50:59.999 America/Metlakatla', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999'=datetimeltz'2014-10-10 12:50:59.999 -9:00', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999 +10:00'=datetimeltz'2014-10-10 14:50:59.999 +11:00', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999 Asia/Seoul'=datetimeltz'2014-10-10 13:50:59.999 Asia/Tokyo', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999 Asia/Seoul'=datetimeltz'2014-10-10 13:50:59.999 +9:00', 'ok', 'nok');

set timezone 'Asia/Ho_Chi_Minh';
select if(datetimetz'2014-10-10 13:50:59.999'<datetimetz'2014-10-10 13:50:59.999 +6:00', 'ok', 'nok');
select if(datetimetz'2014-10-10 13:50:59.999'>datetimetz'2014-10-10 13:50:59.999 +8:00', 'ok', 'nok');
select if(datetimetz'2014-10-10 13:50:59.999'>datetimetz'2014-10-10 13:50:59.999 Asia/Shanghai', 'ok', 'nok');
select if(datetimetz'2014-10-10 13:50:59.999 +0:00'<=datetimetz'2014-10-10 13:50:59.999 -2:00', 'ok', 'nok');

--test: constant DST values
set timezone 'Asia/Tehran';
select if(datetimeltz'2025-07-01 13:00:00.999'=datetimetz'2025-07-01 13:00:00.999 +3:30', 'nok', 'ok');
select if(datetimeltz'2025-07-01 13:00:00.999'<datetimetz'2025-07-01 13:00:00.999 +3:30', 'ok', 'nok');
select if(datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0330'>datetimetz'2025-09-21 23:00:00.999 Asia/Tehran +0430', 'ok', 'nok');  
select if(datetimeltz'2025-09-22 00:00:00.999 Asia/Tehran +0330'!=datetimetz'2025-09-21 23:00:00.999 Asia/Tehran +0430', 'ok', 'nok');  
--test: ambiguous value
select if(datetimeltz'2025-09-21 23:00:00.999'<datetimetz'2025-09-21 23:00:00.999 +3:30', 'ok', 'nok');
--test: [er] non-existent value
--BUG: CUBRIDSUS-16370, resolved
select datetimeltz'2025-03-22 12:00:00.999 AM';
select datetimetz'2025-09-22 00:00:00.999 Asia/Tehran +0430';
select if(datetimeltz'2025-03-22 12:00:00.999 AM +3:00'>=datetimetz'2025-03-22 1:00:00.999 AM', 'ok', 'nok');
select if(datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0330'>datetimetz'2025-09-21 23:00:00.999 Asia/Tehran +0430', 'ok', 'nok');        

--test: ps
prepare st from 'select if(?=?, ''ok'', ''nok'')';
execute st using datetimetz'2025-07-01 13:00:00.999', datetimetz'2025-07-01 13:00:00.999 +4:30';
deallocate prepare st;

prepare st from 'select if(?>?, ''ok'', ''nok'')';
execute st using datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0330', datetimetz'2025-09-21 23:00:00.999 Asia/Tehran +0430';
deallocate prepare st;

prepare st from 'select if(?>=?, ''nok'', ''ok'')';
execute st using datetimeltz'2025-03-22 12:00:00.999 AM +3:00', datetime'2025-03-22 12:00:00.999 AM';
deallocate prepare st;


set timezone 'Asia/Seoul';

--+ holdcas off;
