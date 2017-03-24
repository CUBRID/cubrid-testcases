--test arithmetic operators with TIMESTAMP(L)TZ constant values as operands

set system parameters 'tz_leap_second_support=yes';

--test: ts +/- numeric
set timezone '-8:00';
select if(timestampltz'2014-10-10 13:50:59'+1=timestamptz'2014-10-10 13:51:00 -8:00', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59'-1=timestamptz'2014-10-10 13:50:58 America/Metlakatla', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59'+3600=timestamptz'2014-10-10 13:50:59 -9:00', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59 +10:00'-7200=timestamptz'2014-10-10 14:50:59 +13:00', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59 Asia/Seoul'+3600=timestamptz'2014-10-10 13:50:59 Asia/Chongqing', 'ok', 'nok');
select if(timestampltz'2014-10-10 13:50:59 Asia/Seoul'-3600=timestamptz'2014-10-10 13:50:59 +10:00', 'ok', 'nok');

--test: ts - ts
set timezone 'Asia/Ho_Chi_Minh'; 
-- +7:00
select if(timestamptz'2014-10-10 13:50:59'-timestampltz'2014-10-10 13:50:59 +6:00'=-3600, 'ok', 'nok');
select if(timestamptz'2014-10-10 13:50:59'-timestampltz'2014-10-10 13:50:59 +8:00'=3600, 'ok', 'nok');
select if(timestamptz'2014-10-10 13:50:59'-timestampltz'2014-10-10 13:50:59 Asia/Shanghai'=3600, 'ok', 'nok');
select if(timestamptz'2014-10-10 13:50:59 +0:00'-timestampltz'2014-10-10 13:50:59 -2:00'=-7200, 'ok', 'nok');
--test: [er] ts + ts
select timestamptz'2014-10-10 13:50:59 +0:00'+timestampltz'2014-10-10 13:50:59 -2:00';

--test: DST values
set timezone 'Asia/Tehran';
-- +3:30
select if(timestamptz'2025-07-01 13:00:00'+3600=timestampltz'2025-07-01 13:00:00 +3:30', 'ok', 'nok');
select if(timestamptz'2025-07-01 13:00:00'-timestampltz'2025-07-01 13:00:00 +3:30'=-3600, 'ok', 'nok');
select if(timestamptz'2025-09-21 23:00:00 Asia/Tehran +0330'-timestampltz'2025-09-21 23:00:00 Asia/Tehran +0430'=3600, 'ok', 'nok');
select if(timestamptz'2025-09-21 23:59:59 Asia/Tehran +0430'+1=timestampltz'2025-09-21 23:00:00 Asia/Tehran +0330', 'ok', 'nok');
--test: ambiguous value
select timestamptz'2025-09-21 23:00:00'-1;
--test: [er] non-existent value
--BUG: CUBRIDSUS-15041, resolved
select timestampltz'2025-03-22 12:00:00 AM +3:30';
--BUG: CUBRIDSUS-15181, resolved
select if(timestamptz'2025-03-21 23:59:59'+1=timestampltz'2025-03-22 1:00:00', 'ok', 'nok');
select if(timestamptz'2025-03-22 1:00:00'-1=timestampltz'2025-03-21 23:59:59', 'ok', 'nok');

--test: leap seconds
select if(timestamptz'2012-06-30 23:59:59 UTC'+1=timestampltz'2012-06-30 23:59:59 UTC', 'ok', 'nok'); 
select if(timestamptz'2012-06-30 23:59:59 UTC'+2=timestampltz'2012-07-01 12:00:00 AM UTC', 'ok', 'nok'); 
select if(timestamptz'2012-07-01 4:29:59'+1=timestampltz'2012-07-01 4:29:59', 'ok', 'nok');
select if(timestamptz'2012-07-01 4:29:59'+2=timestampltz'2012-07-01 4:30:00', 'ok', 'nok');
select if(timestamptz'2012-07-01 12:00:00 AM UTC'-timestampltz'2012-06-30 23:59:59 UTC'=2, 'ok', 'nok');
select if(timestamptz'2012-07-01 4:30:00'-timestampltz'2012-07-01 4:29:59'=2, 'ok', 'nok');
select if(timestamptz'2012-06-30 23:59:59 UTC'-timestampltz'2012-06-30 23:59:59 UTC'=0, 'ok', 'nok');



set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
