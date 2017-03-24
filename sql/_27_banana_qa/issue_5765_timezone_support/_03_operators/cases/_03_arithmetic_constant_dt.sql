--test arithmetic operators with DATETIME(L)TZ constant values as operands


--test: ts +/- numeric
set timezone '-8:00';
select if(datetimeltz'2014-10-10 13:50:59.999'+1000=datetimetz'2014-10-10 13:51:00.999 -8:00', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999'-1000=datetimetz'2014-10-10 13:50:58.999 America/Metlakatla', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999'+3600*1000=datetimetz'2014-10-10 13:50:59.999 -9:00', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999 +10:00'-7200*1000=datetimetz'2014-10-10 14:50:59.999 +13:00', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999 Asia/Seoul'+3600*1000=datetimetz'2014-10-10 13:50:59.999 Asia/Chongqing', 'ok', 'nok');
select if(datetimeltz'2014-10-10 13:50:59.999 Asia/Seoul'-3600*1000=datetimetz'2014-10-10 13:50:59.999 +10:00', 'ok', 'nok');

--test: ts - ts
set timezone 'Asia/Ho_Chi_Minh'; 
-- +7:00
select if(datetimetz'2014-10-10 13:50:59.999'-datetimeltz'2014-10-10 13:50:59.999 +6:00'=-3600*1000, 'ok', 'nok');
select if(datetimetz'2014-10-10 13:50:59.999'-datetimeltz'2014-10-10 13:50:59.999 +8:00'=3600*1000, 'ok', 'nok');
select if(datetimetz'2014-10-10 13:50:59.999'-datetimeltz'2014-10-10 13:50:59.999 Asia/Shanghai'=3600*1000, 'ok', 'nok');
select if(datetimetz'2014-10-10 13:50:59.999 +0:00'-datetimeltz'2014-10-10 13:50:59.999 -2:00'=-7200*1000, 'ok', 'nok');
--test: [er] ts + ts
select datetimetz'2014-10-10 13:50:59.999 +0:00'+datetimeltz'2014-10-10 13:50:59.999 -2:00';

--test: DST values
set timezone 'Asia/Tehran';
-- +3:30
select if(datetimetz'2025-07-01 13:00:00.999'+3600*1000=datetimeltz'2025-07-01 13:00:00.999 +3:30', 'ok', 'nok');
select if(datetimetz'2025-07-01 13:00:00.999'-datetimeltz'2025-07-01 13:00:00.999 +3:30'=-3600*1000, 'ok', 'nok');
select if(datetimetz'2025-09-21 23:00:00.999 Asia/Tehran +0430'-datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0430'=3600*1000, 'ok', 'nok');
select if(datetimetz'2025-09-21 23:59:59.999 Asia/Tehran +0430'+1000=datetimeltz'2025-09-21 23:00:00.999 Asia/Tehran +0430', 'ok', 'nok');
--test: ambiguous value
select datetimetz'2025-09-21 23:00:00.999'-1000;
--test: [er] non-existent value
--BUG: CUBRIDSUS-15041, resolved
select datetimeltz'2025-03-22 12:00:00.999 AM +3:30';
--BUG: CUBRIDSUS-15181, resolved
select if(datetimetz'2025-03-21 23:59:59.999'+1000=datetimeltz'2025-03-22 1:00:00.999', 'ok', 'nok');
select if(datetimetz'2025-03-22 1:00:00.999'-1000=datetimeltz'2025-03-21 23:59:59.999', 'ok', 'nok');

--test: leap seconds
select if(datetimetz'2012-06-30 23:59:59.999 UTC'+1000=datetimeltz'2012-07-01 12:00:00.999 AM UTC', 'ok', 'nok'); 
select if(datetimetz'2012-06-30 23:59:59.999 UTC'+2000=datetimeltz'2012-07-01 12:00:01.999 AM UTC', 'ok', 'nok'); 
select if(datetimetz'2012-07-01 4:29:59.999'+1000=datetimeltz'2012-07-01 4:30:00.999', 'ok', 'nok');
select if(datetimetz'2012-07-01 4:29:59.999'+2000=datetimeltz'2012-07-01 4:30:01.999', 'ok', 'nok');
select if(datetimetz'2012-07-01 12:00:00.999 AM UTC'-datetimeltz'2012-06-30 23:59:59.999 UTC'=1000, 'ok', 'nok');
select if(datetimetz'2012-07-01 4:30:00.999'-datetimeltz'2012-07-01 4:29:59.999'=1000, 'ok', 'nok');
select if(datetimetz'2012-06-30 23:59:59.999 UTC'-datetimeltz'2012-06-30 23:59:59.999 UTC'=0, 'ok', 'nok');



set timezone 'Asia/Seoul';
