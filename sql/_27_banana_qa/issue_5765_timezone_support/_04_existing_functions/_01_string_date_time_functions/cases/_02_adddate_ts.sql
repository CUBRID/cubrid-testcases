--test adddate/date_add functions with TIMESTAMP(L)TZ columns as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

drop table if exists tz_test;

create table tz_test(id int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

--test: normal values
insert into tz_test values(1, timestampltz'2014-02-28 23:59:59 -8:00', '2014-02-28 23:59:59 -8:00', '2014-02-28 23:59:59 -8:00');
select if(adddate(ts, interval 1000 millisecond)=timestamptz'2014-03-01 12:00:00 AM -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(adddate(tsltz, interval 1000 millisecond)=timestampltz'2014-03-01 12:00:00 AM -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(adddate(tstz, interval 1000 millisecond)=timestamptz'2014-03-01 12:00:00 AM -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 

insert into tz_test values(2, timestamptz'2014-02-28 23:59:59 Asia/Shanghai', '2014-02-28 23:59:59 Asia/Shanghai', '2014-02-28 23:59:59 Asia/Shanghai');
select if(adddate(ts, interval 1 second)=timestampltz'2014-03-01 12:00:00 AM +8:00', 'ok', 'nok') from tz_test where id=2 order by 1;
select if(adddate(tsltz, interval 1 second)=timestamptz'2014-03-01 12:00:00 AM +8:00', 'ok', 'nok') from tz_test where id=2 order by 1;
select if(adddate(tstz, interval 1 second)=timestamptz'2014-03-01 12:00:00 AM +8:00', 'ok', 'nok') from tz_test where id=2 order by 1;

insert into tz_test values(3, timestamptz'2014-02-28 23:50:00', timestamptz'2014-02-28 23:50:00', timestamptz'2014-02-28 23:50:00'); 
select if(adddate(ts, interval 10 minute)=timestampltz'2014-03-01 12:00:00 AM +9:00', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(adddate(tstz, interval 10 minute)=timestamptz'2014-03-01 12:00:00 AM +9:00', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(adddate(tsltz, interval 10 minute)=timestampltz'2014-03-01 12:00:00 AM +9:00', 'ok', 'nok') from tz_test where id=3 order by 1; 

insert into tz_test values(4, timestampltz'2014-02-28 20:00:00 -9:00', '2014-02-28 20:00:00 -9:00', '2014-02-28 20:00:00 -9:00');
select if(adddate(ts, interval -5 hour)=timestampltz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(adddate(tsltz, interval -5 hour)=timestamptz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(adddate(tstz, interval -5 hour)=timestamptz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 

insert into tz_test values(5, timestamptz'2014-02-28 12:00:00 AM America/New_York', '2014-02-28 12:00:00 AM America/New_York', '2014-02-28 12:00:00 AM America/New_York');
select if(adddate(ts, interval 1 day)=timestamptz'2014-03-01 12:00:00 AM -5:00', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(adddate(tsltz, interval 1 day)=timestampltz'2014-03-01 12:00:00 AM -5:00', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(adddate(tstz, interval 1 day)=timestamptz'2014-03-01 12:00:00 AM -5:00', 'ok', 'nok') from tz_test where id=5 order by 1; 

insert into tz_test values(6, timestamptz'2014-02-28 23:59:59', timestamptz'2014-02-28 23:59:59', timestamptz'2014-02-28 23:59:59');
select if(adddate(tsltz, interval 2 week)=timestamptz'2014-03-14 11:59:59 PM Asia/Pyongyang', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(adddate(ts, interval 10 month)=timestamptz'2014-12-28 22:59:59 Asia/Chongqing', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(adddate(tstz, interval 10 month)=timestampltz'2014-12-28 22:59:59 Asia/Chongqing', 'ok', 'nok') from tz_test where id=6 order by 1; 

insert into tz_test values(7, timestampltz'2012-02-29 23:59:59 +0:00', '2012-02-29 23:59:59 +0:00', '2012-02-29 23:59:59 +0:00');
select if(adddate(ts, interval 12 quarter)=timestampltz'2015-02-28 15:59:59 -8:00', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(adddate(tsltz, interval 12 quarter)=timestamptz'2015-02-28 15:59:59 -8:00', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(adddate(tstz, interval 12 quarter)=timestamptz'2015-02-28 15:59:59 -8:00', 'ok', 'nok') from tz_test where id=7 order by 1; 

insert into tz_test values(8, timestamptz'2012-02-29 12:00:00 AM -8:00', '2012-02-29 12:00:00 AM -8:00', '2012-02-29 12:00:00 AM -8:00');
select if(adddate(ts, interval 9 year)=timestamptz'2021-02-27 22:00:00 -10:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(adddate(tsltz, interval 9 year)=timestampltz'2021-02-27 22:00:00 -10:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(adddate(tstz, interval 9 year)=timestamptz'2021-02-27 22:00:00 -10:00', 'ok', 'nok') from tz_test where id=8 order by 1; 


--test: DST values
set timezone 'America/Argentina/Cordoba';   
-- -03:00

insert into tz_test values(9, timestampltz'2008-10-20 13:58:59', '2008-10-20 13:58:59', '2008-10-20 13:58:59');
select if(date_add(ts, interval '1:1' minute_second)=timestamptz'2008-10-20 16:00:00 UTC', 'ok', 'nok') from tz_test where id=9 order by 1;
select if(date_add(tsltz, interval '1:1' minute_second)=timestamptz'2008-10-20 16:00:00 UTC', 'ok', 'nok') from tz_test where id=9 order by 1;
select if(date_add(tstz, interval '1:1' minute_second)=timestampltz'2008-10-20 16:00:00 UTC', 'ok', 'nok') from tz_test where id=9 order by 1;

insert into tz_test values(10, timestamptz'2008-10-18 22:59:00 -3:00', '2008-10-18 22:59:00 -3:00', '2008-10-18 22:59:00 -3:00');
--BUG: CUBRIDSUS-16750, resolved
--BUG: CUBRIDSUS-17296
select if(date_add(ts, interval '1:1' hour_minute)=timestampltz'2008-10-19 1:00:00 am', 'ok', 'nok') from tz_test where id=10 order by 1;
--BUG: CUBRIDSUS-17265, resolved
select if(date_add(tsltz, interval '1:1' hour_minute)=timestamptz'2008-10-19 1:00:00 am', 'ok', 'nok') from tz_test where id=10 order by 1;
select if(date_add(tstz, interval '1:1' hour_minute)=timestamptz'2008-10-19 1:00:00 am', 'ok', 'nok') from tz_test where id=10 order by 1;

--BUG: CUBRIDSUS-15181, resolved
insert into tz_test values(11, timestampltz'2008-10-17 21:30:00 America/Argentina/Tucuman', '2008-10-17 21:30:00 America/Argentina/Tucuman', '2008-10-17 21:30:00 America/Argentina/Tucuman'); 
select if(date_add(ts, interval '1 5:30:00' day_second)='2008-10-19 4:00:00 AM', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_add(tsltz, interval '1 5:30:00' day_second)='2008-10-19 4:00:00 AM', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_add(tstz, interval '1 5:30:00' day_second)='2008-10-19 4:00:00 AM', 'ok', 'nok') from tz_test where id=11 order by 1;

--BUG: CUBRIDSUS-15181, resolved
insert into tz_test values(12, timestamptz'2006-9-19 21:30:00', timestamptz'2006-9-19 21:30:00', timestamptz'2006-9-19 21:30:00');
select if(date_add(ts, interval '2-1' year_month)='2008-10-19 22:30:00', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_add(tsltz, interval '2-1' year_month)='2008-10-19 22:30:00', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_add(tstz, interval '2-1' year_month)='2008-10-19 22:30:00', 'ok', 'nok') from tz_test where id=12 order by 1;

insert into tz_test values(13, timestampltz'2009-3-14 21:59:59', '2009-3-14 21:59:59', '2009-3-14 21:59:59');
--[error]??
select adddate(ts, interval '2:00:01' hour_second) from tz_test where id=13 order by 1;
select if(adddate(tsltz, interval '2:00:01' hour_second)=datetimetz'2009-3-14 11:00:00 PM America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=13 order by 1;
select if(adddate(tstz, interval '2:00:01' hour_second)=datetimetz'2009-3-14 11:00:00 PM America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=13 order by 1;

insert into tz_test values(14, timestamptz'2009-3-14 23:11:12', '2009-3-14 23:11:12', '2009-3-14 23:11:12');
--BUG: CUBRIDSUS-17263, resolved
select if(adddate(tstz, interval '1' hour)=timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=14 order by 1;
select if(adddate(tsltz, interval '1' hour)=timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=14 order by 1;
select if(adddate(ts, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=14 order by 1;

insert into tz_test values(15, timestampltz'2009-3-14 23:11:12 America/Argentina/Cordoba -02', '2009-3-14 23:11:12 America/Argentina/Cordoba -02', '2009-3-14 23:11:12 America/Argentina/Cordoba -03');
select if(adddate(ts, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=15 order by 1;
select if(adddate(tsltz, interval '1' hour)=(timestamp'2009-3-15 12:11:12 AM' - 3600), 'ok', 'nok') from tz_test where id=15 order by 1;
select if(adddate(tstz, interval '1' hour)='2009-3-15 12:11:12 AM', 'ok', 'nok') from tz_test where id=15 order by 1;

--test: leap seconds
--BUG: CUBRIDSUS-16595
insert into tz_test values(16, timestamptz'2008-12-31 21:59:59', '2008-12-31 21:59:59', '2008-12-31 21:59:59');
select if(date_add(ts, interval '1' second)=timestampltz'2008-12-31 22:00:00', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(date_add(tsltz, interval '1' second)=timestamptz'2008-12-31 22:00:00', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(date_add(tstz, interval '1' second)=timestamptz'2008-12-31 22:00:00', 'ok', 'nok') from tz_test where id=16 order by 1;

insert into tz_test values(17, timestamptz'2008-12-31 21:59:59 America/Argentina/Cordoba', timestamptz'2008-12-31 21:59:59 America/Argentina/Cordoba', timestamptz'2008-12-31 21:59:59 America/Argentina/Cordoba');
select if(date_add(ts, interval '2' second)=timestamptz'2009-01-01 12:00:01 am UTC', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(date_add(tsltz, interval '2' second)='2009-01-01 12:00:01 am UTC', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(date_add(tstz, interval '2' second)='2009-01-01 12:00:01 am UTC', 'ok', 'nok') from tz_test where id=17 order by 1;

insert into tz_test values(18, timestampltz'2008-12-31 22:59:59 +00:00', '2008-12-31 22:59:59 +00:00', '2008-12-31 22:59:59 +00:00');
select if(date_add(ts, interval '1:00:01' hour_second)=timestamptz'2009-1-1 12:00:00 am UTC', 'ok', 'nok') from tz_test where id=18 order by 1;
select if(date_add(tsltz, interval '1:00:01' hour_second)=timestamptz'2009-1-1 12:00:00 am UTC', 'ok', 'nok') from tz_test where id=18 order by 1;
select if(date_add(tstz, interval '1:00:01' hour_second)=timestampltz'2009-1-1 12:00:00 am UTC', 'ok', 'nok') from tz_test where id=18 order by 1;

insert into tz_test values(19, timestampltz'2008-12-31 22:59:59 UTC', '2008-12-31 22:59:59 UTC', '2008-12-31 22:59:59 UTC');
select if(date_add(tstz, interval '1:00:02' hour_second)='2009-01-01 12:00:01 AM UTC', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(date_add(tsltz, interval '1:00:02' hour_second)='2009-01-01 12:00:01 AM UTC', 'ok', 'nok') from tz_test where id=19 order by 1;
select if(date_add(tstz, interval '1:00:02' hour_second)='2009-01-01 12:00:01 AM UTC', 'ok', 'nok') from tz_test where id=19 order by 1;

--test: adddate
insert into tz_test values(20, timestamptz'2008-10-18 22:59:00', timestampltz'2008-10-18 22:59:00', timestamptz'2008-10-18 22:59:00');
select * from tz_test where id=20;
--BUG: CUBRIDSUS-17297
select if(adddate(ts, 1)='2008-10-19 23:59:00', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(adddate(tsltz, 1)='2008-10-19 23:59:00', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(adddate(tstz, 1)='2008-10-19 23:59:00', 'ok', 'nok') from tz_test where id=20 order by 1;

insert into tz_test values(21, timestamptz'2009-3-14 23:11:12 America/Argentina/Cordoba', '2009-3-14 23:11:12 America/Argentina/Cordoba', '2009-3-14 23:11:12 America/Argentina/Cordoba');
select if(adddate(ts, 1)=timestamptz'2009-3-15 22:11:12', 'ok', 'nok') from tz_test where id=21 order by 1;
select if(adddate(tsltz, 1)=timestamptz'2009-3-15 22:11:12', 'ok', 'nok') from tz_test where id=21 order by 1;
select if(adddate(tstz, 1)=timestamptz'2009-3-15 22:11:12', 'ok', 'nok') from tz_test where id=21 order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
