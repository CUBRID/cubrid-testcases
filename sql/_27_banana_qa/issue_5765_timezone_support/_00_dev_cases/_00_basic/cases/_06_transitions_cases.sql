-- since 1988 (9th Oct 0:00) there is no DST in Korea, expect to fail
set system parameters 'tz_leap_second_support=yes';
select  datetimetz'2001-10-09 10:11:12 Asia/Seoul KST';


-- Winter to Summer time
-- ok
select  datetimetz'1988-05-08 1:11:12 Asia/Seoul KST';
select  datetimetz'1988-05-08 1:11:12 Asia/Seoul';
-- fail (still in KST)
select  datetimetz'1988-05-08 1:11:12 Asia/Seoul KDT';

-- fail: this hour does not exit
select  datetimetz'1988-05-08 02:11:12 Asia/Seoul KST';
-- fail: this hour does not exit
select  datetimetz'1988-05-08 02:11:12 Asia/Seoul KDT';
-- fail: this hour does not exit
select  datetimetz'1988-05-08 02:11:12 Asia/Seoul';

-- fail (now is KDT)
select  datetimetz'1988-05-08 03:11:12 Asia/Seoul KST';
-- ok
select  datetimetz'1988-05-08 03:11:12 Asia/Seoul KDT';
select  datetimetz'1988-05-08 03:11:12 Asia/Seoul';

select  datetimetz'1988-05-08 03:11:12 Asia/Seoul KDT' - datetimetz'1988-05-08 1:11:12 Asia/Seoul KST', (datetimetz'1988-05-08 03:11:12 Asia/Seoul KDT' - datetimetz'1988-05-08 1:11:12 Asia/Seoul KST')/ (3600 * 1000);

select  timediff (datetimetz'1988-05-08 03:11:12 Asia/Seoul KDT', datetimetz'1988-05-08 1:11:12 Asia/Seoul KST');




-- Summer to Winter
-- ok, clocks at 0:00 on 9th are set backwards 1 hour, so it will be 8th 23:00:00
select  datetimetz'1988-10-09 2:11:12 Asia/Seoul KST';
-- ok
select  datetimetz'1988-10-09 2:11:12 Asia/Seoul KDT';
-- ok: ambiguity, we choose the previous time (KDT)
select  datetimetz'1988-10-09 2:11:12 Asia/Seoul';

-- ok
select  datetimetz'1988-10-09 03:11:12 Asia/Seoul KST';
select  datetimetz'1988-10-09 03:11:12 Asia/Seoul';
-- fail
select  datetimetz'1988-10-09 03:11:12 Asia/Seoul KDT';




select  datetimetz'1988-10-09 03:11:12 Asia/Seoul KST' - datetimetz'1988-10-09 2:11:12 Asia/Seoul KDT', (datetimetz'1988-10-09 03:11:12 Asia/Seoul KST' - datetimetz'1988-10-09 2:11:12 Asia/Seoul KDT')/ (3600 * 1000);

select  timediff (datetimetz'1988-10-09 03:11:12 Asia/Seoul KST', datetimetz'1988-10-09 2:11:12 Asia/Seoul KDT');

-------------

-- from Summer time to Winter time:
-- ok
select  datetimetz'2013-10-27 02:11:12 Europe/Bucharest EEST';
select  datetimetz'2013-10-27 02:59:59.999 Europe/Bucharest EEST';
-- nok, we are still in EEST
select  datetimetz'2013-10-27 02:11:12 Europe/Bucharest EET';


-- ok, ambiguity resolved by DST
select  datetimetz'2013-10-27 03:11:12 Europe/Bucharest EEST';
-- ok, ambiguity resolved by DST
select  datetimetz'2013-10-27 03:11:12 Europe/Bucharest EET';

-- ok, ambiguity EEST or EET : choose first time (EEST)
select  datetimetz'2013-10-27 03:11:12 Europe/Bucharest'; 

-- ok
select  datetimetz'2013-10-27 04:11:12 Europe/Bucharest EET'; 
-- fail
select  datetimetz'2013-10-27 04:11:12 Europe/Bucharest EEST';

select  datetimetz'2013-10-27 04:11:12 Europe/Bucharest EET' - datetimetz'2013-10-27 02:11:12 Europe/Bucharest EEST', (datetimetz'2013-10-27 04:11:12 Europe/Bucharest EET' - datetimetz'2013-10-27 02:11:12 Europe/Bucharest EEST')/ (3600 * 1000);

select  timediff (datetimetz'2013-10-27 04:11:12 Europe/Bucharest EET', datetimetz'2013-10-27 02:11:12 Europe/Bucharest EEST');


-- from Winter time to Summer time:
-- nok, we are still in EET
select  datetimetz'2013-03-31 02:11:12 Europe/Bucharest EEST'; 
-- ok, we are still in EET
select  datetimetz'2013-03-31 02:11:12 Europe/Bucharest EET';
-- ok, we are still in EET
select  datetimetz'2013-03-31 02:59:59.999 Europe/Bucharest EET';



-- nok, this hour does not exist in DS leap interval
select  datetimetz'2013-03-31 03:11:12 Europe/Bucharest EEST';
-- nok, this hour does not exist in DS leap interval
select  datetimetz'2013-03-31 03:11:12 Europe/Bucharest EET';
-- nok, this hour does not exist in DS leap interval
select  datetimetz'2013-03-31 03:11:12 Europe/Bucharest';      

-- nok (we are now in EEST)
select  datetimetz'2013-03-31 04:11:12 Europe/Bucharest EET';
-- ok
select  datetimetz'2013-03-31 04:11:12 Europe/Bucharest EEST';




select  datetimetz'2013-03-31 04:11:12 Europe/Bucharest EEST' - datetimetz'2013-03-31 02:11:12 Europe/Bucharest EET', (datetimetz'2013-03-31 04:11:12 Europe/Bucharest EEST' - datetimetz'2013-03-31 02:11:12 Europe/Bucharest EET')/ (3600 * 1000);

select  timediff (datetimetz'2013-03-31 04:11:12 Europe/Bucharest EEST', datetimetz'2013-03-31 02:11:12 Europe/Bucharest EET');
set system parameters 'tz_leap_second_support=no';
