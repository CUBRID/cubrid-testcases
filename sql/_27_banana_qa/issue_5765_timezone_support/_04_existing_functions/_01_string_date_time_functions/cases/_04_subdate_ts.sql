--test subdate/date_sub functions with TIMESTAMP(L)TZ columns as arguments
set system parameters 'tz_leap_second_support=yes';


set timezone 'Asia/Seoul';

drop table if exists tz_test;

create table tz_test(id int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

--test: normal values
insert into tz_test values(1, timestampltz'2014-03-01 12:00:00 AM -8:00', timestampltz'2014-03-01 12:00:00 AM -8:00', timestamptz'2014-03-01 12:00:00 AM -8:00');
select if(subdate(ts, interval 1000 millisecond)=timestampltz'2014-02-28 23:59:59 -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(subdate(tsltz, interval 1000 millisecond)=timestampltz'2014-02-28 23:59:59 -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 
select if(subdate(tstz, interval 1000 millisecond)=timestampltz'2014-02-28 23:59:59 -8:00', 'ok', 'nok') from tz_test where id=1 order by 1; 

insert into tz_test values(2, timestampltz'2014-03-01 12:00:00 AM Asia/Shanghai', timestampltz'2014-03-01 12:00:00 AM Asia/Shanghai', timestamptz'2014-03-01 12:00:00 AM Asia/Shanghai');
select if(subdate(ts, interval 1 second)=timestampltz'2014-02-28 23:59:59 +8:00', 'ok', 'nok') from tz_test where id=2 order by 1; 
select if(subdate(tsltz, interval 1 second)=timestampltz'2014-02-28 23:59:59 +8:00', 'ok', 'nok') from tz_test where id=2 order by 1; 
select if(subdate(tstz, interval 1 second)=timestampltz'2014-02-28 23:59:59 +8:00', 'ok', 'nok') from tz_test where id=2 order by 1; 

insert into tz_test values(3, timestampltz'2014-03-01 12:00:00 AM +9:00', timestampltz'2014-03-01 12:00:00 AM +9:00', timestamptz'2014-03-01 12:00:00 AM +9:00');
select if(subdate(ts, interval 10 minute)=timestampltz'2014-02-28 23:50:00', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(subdate(tsltz, interval 10 minute)=timestampltz'2014-02-28 23:50:00', 'ok', 'nok') from tz_test where id=3 order by 1; 
select if(subdate(tstz, interval 10 minute)=timestampltz'2014-02-28 23:50:00', 'ok', 'nok') from tz_test where id=3 order by 1; 

insert into tz_test values(4, timestampltz'2014-02-28 20:00:00', timestampltz'2014-02-28 20:00:00', timestamptz'2014-02-28 20:00:00');
select if(subdate(ts, interval 5 hour)=timestampltz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(subdate(tsltz, interval 5 hour)=timestampltz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 
select if(subdate(tstz, interval 5 hour)=timestampltz'2014-03-01 12:00:00 AM UTC', 'ok', 'nok') from tz_test where id=4 order by 1; 

insert into tz_test values(5, '2014-03-01 12:00:00 AM -5:00', '2014-03-01 12:00:00 AM -5:00', '2014-03-01 12:00:00 AM -5:00');
select if(subdate(ts, interval 1 day)=timestampltz'2014-02-28 12:00:00 AM American/New_York', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(subdate(tsltz, interval 1 day)=timestampltz'2014-02-28 12:00:00 AM American/New_York', 'ok', 'nok') from tz_test where id=5 order by 1; 
select if(subdate(tstz, interval 1 day)=timestampltz'2014-02-28 12:00:00 AM American/New_York', 'ok', 'nok') from tz_test where id=5 order by 1; 

insert into tz_test values(6, timestampltz'2014-03-14 11:59:59 PM Asia/Pyongyang', timestampltz'2014-03-14 11:59:59 PM Asia/Pyongyang', timestamptz'2014-03-14 11:59:59 PM Asia/Pyongyang');
select if(subdate(ts, interval 2 week)=timestampltz'2014-02-28 23:59:59', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(subdate(tsltz, interval 2 week)=timestampltz'2014-02-28 23:59:59', 'ok', 'nok') from tz_test where id=6 order by 1; 
select if(subdate(tstz, interval 2 week)=timestampltz'2014-02-28 23:59:59', 'ok', 'nok') from tz_test where id=6 order by 1; 

insert into tz_test values(7, timestampltz'2014-12-28 23:59:59', timestampltz'2014-12-28 23:59:59', timestamptz'2014-12-28 23:59:59');
select if(subdate(ts, interval 10 month)=timestampltz'2014-2-28 22:59:59 Asia/Chongqing', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(subdate(tsltz, interval 10 month)=timestampltz'2014-2-28 22:59:59 Asia/Chongqing', 'ok', 'nok') from tz_test where id=7 order by 1; 
select if(subdate(tstz, interval 10 month)=timestampltz'2014-2-28 22:59:59 Asia/Chongqing', 'ok', 'nok') from tz_test where id=7 order by 1; 

insert into tz_test values(8, timestampltz'2015-02-28 15:59:59 -8:00', timestampltz'2015-02-28 15:59:59 -8:00', timestamptz'2015-02-28 15:59:59 -8:00');
select if(subdate(ts, interval 12 quarter)=timestampltz'2012-02-29 23:59:59 +0:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(subdate(tsltz, interval 12 quarter)=timestampltz'2012-02-29 23:59:59 +0:00', 'ok', 'nok') from tz_test where id=8 order by 1; 
select if(subdate(tstz, interval 12 quarter)=timestampltz'2012-02-29 23:59:59 +0:00', 'ok', 'nok') from tz_test where id=8 order by 1; 

insert into tz_test values(9, timestampltz'2021-02-27 22:00:00 -10:00', timestampltz'2021-02-27 22:00:00 -10:00', timestamptz'2021-02-27 22:00:00 -10:00');
select if(subdate(ts, interval 9 year)=timestampltz'2014-02-29 12:00:00 AM -8:00', 'ok', 'nok') from tz_test where id=9 order by 1; 
select if(subdate(tsltz, interval 9 year)=timestampltz'2014-02-29 12:00:00 AM -8:00', 'ok', 'nok') from tz_test where id=9 order by 1; 
select if(subdate(tstz, interval 9 year)=timestampltz'2014-02-29 12:00:00 AM -8:00', 'ok', 'nok') from tz_test where id=9 order by 1; 

--test: DST values
set timezone 'America/Argentina/Cordoba' from tz_test where id=1 order by 1;   
-- -03:00

insert into tz_test values(10, '2008-10-20 13:58:59', '2008-10-20 13:58:59', '2008-10-20 13:58:59');
select if(date_sub(ts, interval '-1:1' minute_second)=timestampltz'2008-10-20 16:00:00 UTC', 'ok', 'nok') from tz_test where id=10 order by 1;
select if(date_sub(tsltz, interval '-1:1' minute_second)=timestampltz'2008-10-20 16:00:00 UTC', 'ok', 'nok') from tz_test where id=10 order by 1;
select if(date_sub(tstz, interval '-1:1' minute_second)=timestampltz'2008-10-20 16:00:00 UTC', 'ok', 'nok') from tz_test where id=10 order by 1;

insert into tz_test values(11, '2008-10-20 13:00:00', '2008-10-20 13:00:00', '2008-10-20 13:00:00');
select if(date_sub(ts, interval '1:1' minute_second)=timestampltz'2008-10-20 16:58:59 UTC', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_sub(tsltz, interval '1:1' minute_second)=timestampltz'2008-10-20 16:58:59 UTC', 'ok', 'nok') from tz_test where id=11 order by 1;
select if(date_sub(tstz, interval '1:1' minute_second)=timestampltz'2008-10-20 16:58:59 UTC', 'ok', 'nok') from tz_test where id=11 order by 1;

insert into tz_test values(12, '2008-10-18 1:00:00 am', '2008-10-18 1:00:00 am', '2008-10-18 1:00:00 am');
select if(date_sub(ts, interval '1:1' hour_minute)=timestampltz'2008-10-17 22:59:00 -3:00', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_sub(tsltz, interval '1:1' hour_minute)=timestampltz'2008-10-17 22:59:00 -3:00', 'ok', 'nok') from tz_test where id=12 order by 1;
select if(date_sub(tstz, interval '1:1' hour_minute)=timestampltz'2008-10-17 22:59:00 -3:00', 'ok', 'nok') from tz_test where id=12 order by 1;

insert into tz_test values(13, '2008-10-18 4:00:00 AM America/Argentina/Tucuman', '2008-10-18 4:00:00 AM America/Argentina/Tucuman', '2008-10-18 4:00:00 AM America/Argentina/Tucuman');
select if(date_sub(ts, interval '1 5:30:30' day_second)='2008-10-16 21:30:00', 'ok', 'nok') from tz_test where id=13 order by 1;
select if(date_sub(tsltz, interval '1 5:30:30' day_second)='2008-10-16 21:30:00', 'ok', 'nok') from tz_test where id=13 order by 1;
select if(date_sub(tstz, interval '1 5:30:30' day_second)='2008-10-16 21:30:00', 'ok', 'nok') from tz_test where id=13 order by 1;

insert into tz_test values(14, timestampltz'2008-10-18 22:30:00', timestampltz'2008-10-18 22:30:00', timestamptz'2008-10-18 22:30:00');
select if(date_sub(ts, interval '2-1' year_month)='2006-9-18 21:30:00') from tz_test where id=14 order by 1;
select if(date_sub(tsltz, interval '2-1' year_month)='2006-9-18 21:30:00') from tz_test where id=14 order by 1;
select if(date_sub(tstz, interval '2-1' year_month)='2006-9-18 21:30:00') from tz_test where id=14 order by 1;

--[error]??
insert into tz_test values(15, '2009-3-14 21:59:59', '2009-3-14 21:59:59', '2009-3-14 21:59:59');
select subdate(ts, interval '-2:00:01' hour_second) from tz_test where id=15 order by 1;
select subdate(tsltz, interval '-2:00:01' hour_second) from tz_test where id=15 order by 1;
select subdate(tstz, interval '-2:00:01' hour_second) from tz_test where id=15 order by 1;

insert into tz_test values(16, '2009-3-15 12:30:01 AM', '2009-3-15 12:30:01 AM', '2009-3-15 12:30:01 AM');
select subdate(ts, interval '1:00:01' hour_second) from tz_test where id=16 order by 1;
select subdate(tsltz, interval '1:00:01' hour_second) from tz_test where id=16 order by 1;
select subdate(tstz, interval '1:00:01' hour_second) from tz_test where id=16 order by 1;

select if(subdate(ts, interval '1:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(tsltz, interval '1:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(tstz, interval '1:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;

select if(subdate(ts, interval '2:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(tsltz, interval '2:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(tstz, interval '2:00:01' hour_second)='2009-3-14 11:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;

select if(subdate(ts, interval '3:00:01' hour_second)='2009-3-14 10:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(tsltz, interval '3:00:01' hour_second)='2009-3-14 10:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;
select if(subdate(tstz, interval '3:00:01' hour_second)='2009-3-14 10:30:00 PM', 'ok', 'nok') from tz_test where id=16 order by 1;

--??
insert into tz_test values(17, '2009-3-14 23:11:12', '2009-3-14 23:11:12', '2009-3-14 23:11:12');
select if(subdate(ts, interval '1' hour)=timestampltz'2009-3-14 23:11:12', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(subdate(tsltz, interval '1' hour)=timestampltz'2009-3-14 23:11:12', 'ok', 'nok') from tz_test where id=17 order by 1;
select if(subdate(tstz, interval '1' hour)=timestampltz'2009-3-14 23:11:12', 'ok', 'nok') from tz_test where id=17 order by 1;

insert into tz_test values(18, '2009-3-14 23:11:12  America/Argentina/Cordoba', '2009-3-14 23:11:12  America/Argentina/Cordoba', '2009-3-14 23:11:12  America/Argentina/Cordoba');
select if(subdate(ts, interval '1' hour)=timestampltz'2009-3-14 23:11:12') from tz_test where id=18 order by 1;
select if(subdate(tsltz, interval '1' hour)=timestampltz'2009-3-14 23:11:12') from tz_test where id=18 order by 1;
select if(subdate(tstz, interval '1' hour)=timestampltz'2009-3-14 23:11:12') from tz_test where id=18 order by 1;

insert into tz_test values(19, '2009-3-14 23:11:12 America/Argentina/Cordoba -03', '2009-3-14 23:11:12 America/Argentina/Cordoba -03', '2009-3-14 23:11:12 America/Argentina/Cordoba -03');
select if(subdate(ts, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba'), 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(tsltz, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba'), 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(tstz, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba'), 'ok', 'nok') from tz_test where id=19 order by 1;

select if(subdate(ts, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02'), 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(tsltz, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02'), 'ok', 'nok') from tz_test where id=19 order by 1;
select if(subdate(tstz, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02'), 'ok', 'nok') from tz_test where id=19 order by 1;

insert into tz_test values(20, '2009-3-15 12:11:12 AM', '2009-3-15 12:11:12 AM', '2009-3-15 12:11:12 AM');
select if(subdate(ts, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(tsltz, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(tstz, interval '1' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -03', 'ok', 'nok') from tz_test where id=20 order by 1;

select if(subdate(ts, interval '2' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(tsltz, interval '2' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=20 order by 1;
select if(subdate(tstz, interval '2' hour)='2009-3-14 23:11:12 America/Argentina/Cordoba -02', 'ok', 'nok') from tz_test where id=20 order by 1;

--[er]
insert into tz_test values(21, '2009-3-14 23:11:12 America/Argentina/Cordoba KST', '2009-3-14 23:11:12 America/Argentina/Cordoba KST', '2009-3-14 23:11:12 America/Argentina/Cordoba KST');
select if(subdate(ts, interval '1' hour)='2009-3-15 12:11:12 AM', 'ok', 'nok') from tz_test where id=21 order by 1;
select if(subdate(tsltz, interval '1' hour)='2009-3-15 12:11:12 AM', 'ok', 'nok') from tz_test where id=21 order by 1;
select if(subdate(tstz, interval '1' hour)='2009-3-15 12:11:12 AM', 'ok', 'nok') from tz_test where id=21 order by 1;

--test: leap seconds
insert into tz_test values(22, '2008-12-31 20:59:59', '2008-12-31 20:59:59', '2008-12-31 20:59:59');
select if(date_sub(ts, interval '-1' second)=timestampltz'2008-12-31 20:59:59', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(tsltz, interval '-1' second)=timestampltz'2008-12-31 20:59:59', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(tstz, interval '-1' second)=timestampltz'2008-12-31 20:59:59', 'ok', 'nok') from tz_test where id=22 order by 1;

select if(date_sub(ts, interval '1' second)=timestampltz'2008-12-31 20:59:59', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(tsltz, interval '1' second)=timestampltz'2008-12-31 20:59:59', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(tstz, interval '1' second)=timestampltz'2008-12-31 20:59:59', 'ok', 'nok') from tz_test where id=22 order by 1;

select if(date_sub(ts, interval '-2' second)='2009-01-01 12:00:00 am UTC', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(tsltz, interval '-2' second)='2009-01-01 12:00:00 am UTC', 'ok', 'nok') from tz_test where id=22 order by 1;
select if(date_sub(tstz, interval '-2' second)='2009-01-01 12:00:00 am UTC', 'ok', 'nok') from tz_test where id=22 order by 1;

insert into tz_test values(23, timestampltz'2008-12-31 21:00:00 America/Argentina/Cordoba', timestampltz'2008-12-31 21:00:00 America/Argentina/Cordoba', timestamptz'2008-12-31 21:00:00 America/Argentina/Cordoba');
select if(date_sub(ts, interval '2' second)='2008-12-31 20:59:59 am', 'ok', 'nok') from tz_test where id=23 order by 1;
select if(date_sub(tsltz, interval '2' second)='2008-12-31 20:59:59 am', 'ok', 'nok') from tz_test where id=23 order by 1;
select if(date_sub(tstz, interval '2' second)='2008-12-31 20:59:59 am', 'ok', 'nok') from tz_test where id=23 order by 1;

insert into tz_test values(24, timestampltz'2009-01-01 12:00:00 am UTC', timestampltz'2009-01-01 12:00:00 am UTC', timestamptz'2009-01-01 12:00:00 am UTC');
select if(date_sub(ts, interval '1' second)='2008-12-31 20:59:59 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=24 order by 1;
select if(date_sub(tsltz, interval '2' second)='2008-12-31 20:59:59 America/Argentina/Cordoba', 'ok', 'nok') from tz_test where id=24 order by 1;
select if(date_sub(tstz, interval '1:00:01' hour_second)=timestampltz'2008-12-31 22:59:59 UTC', 'ok', 'nok') from tz_test where id=24 order by 1;
select if(date_sub(tstz, interval '1:00:02' hour_second)=timestampltz'2008-12-31 22:59:59 UTC', 'ok', 'nok') from tz_test where id=24 order by 1;

--test: subdate
insert into tz_test values(25, timestampltz'2008-10-19 23:59:00', timestampltz'2008-10-19 23:59:00', timestamptz'2008-10-19 23:59:00');
select if(subdate(ts, 1)='2008-10-18 23:59:00', 'ok', 'nok') from tz_test where id=25 order by 1;
select if(subdate(tsltz, 1)='2008-10-18 22:59:00', 'ok', 'nok') from tz_test where id=25 order by 1;
select if(subdate(tstz, 1)='2008-10-18 22:59:00', 'ok', 'nok') from tz_test where id=25 order by 1;

insert into tz_test values(26, '2009-3-15 22:11:12 America/Argentina/Cordoba', '2009-3-15 22:11:12 America/Argentina/Cordoba', '2009-3-15 22:11:12 America/Argentina/Cordoba');
select if(subdate(ts, 1)=timestampltz'2009-3-14 22:11:12', 'ok', 'nok') from tz_test where id=26 order by 1;
select if(subdate(tsltz, 1)=timestampltz'2009-3-14 23:11:12', 'ok', 'nok') from tz_test where id=26 order by 1;
select if(subdate(tstz, 1)=timestampltz'2009-3-14 23:11:12', 'ok', 'nok') from tz_test where id=26 order by 1;


drop table tz_test;
set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
