--test encryption functions with timestamp(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone, gid int);

insert into tz_test values(1, timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', null, 1);
insert into tz_test values(2, null, timestamptz'1981-01-01 5:00:00 Europe/Vienna', timestamptz'1981-01-01 5:00:00 Europe/Vienna', 3);
insert into tz_test values(3, null, null, timestamptz'1993-12-31 23:00:00 America/Asuncion', 1);
insert into tz_test values(4, timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', 2);
insert into tz_test values(5, timestamptz'2015-08-13 14:00:00 Antarctica/Mawson', timestamptz'2015-08-13 14:00:00 Antarctica/Mawson', null, 3);
insert into tz_test values(6, timestamptz'2023-03-23 18:59:59 Asia/Taipei', null, null, 2);
insert into tz_test values(7, timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', 1);
insert into tz_test values(8, null, timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', 3);
insert into tz_test values(9, null, null, null, 2);

--test: comparison functions
select id, ts, coalesce(ts, 1), tsltz, coalesce(tsltz, ts, 1), tstz, coalesce(tsltz, tstz, 1) from tz_test order by 1;

select id, ts, tsltz, decode(ts, tsltz, 'ts=tsltz', tstz, 'ts=tstz', 'default') as rs from tz_test order by 1;
select id, tstz, tsltz, decode(tsltz, (select max(tstz) from tz_test), 'max', tstz, 'tsltz=tstz', 'default') as rs from tz_test order by 1;
select id, ts, tstz, decode(tstz, (select min(tstz) from tz_test), 'min', ts, tstz, 'default') as rs from tz_test order by 1;
--BUG: CUBRIDSUS-16277
select id, tstz, tsltz, decode(tsltz, (select max(tstz) from tz_test), datetimetz'0001-01-01 10:00:00 AM', tstz, tsltz, timestamptz'0000-00-00 00:00:00') as rs from tz_test order by 1;
--BUG: CUBRIDSUS-17155
select cast(timestamptz'0000-00-00 00:00:00' as datetimetz);

select id, ts, tsltz, tstz, greatest(tstz, tsltz, ts) as greatest from tz_test order by 1;

select id, ts, if (year(ts)=2015, 'year 2015', ts) as rs from tz_test order by 1;
select id, tstz, tsltz, if (tstz=tsltz, 'equal', 'not equal') as rs from tz_test order by 1;

select id, ts, tsltz, ifnull(ts, tsltz) rs from tz_test order by 1;
select id, tstz, tsltz, ifnull(tsltz, tstz) rs from tz_test order by 1;

select id, ts, isnull(ts), tsltz, isnull(tsltz), tstz, isnull(tstz) from tz_test order by 1;

select id, ts, tsltz, tstz, least(tstz, tsltz, ts) least from tz_test order by 1;

select id, tstz, ts, nullif(tstz, ts) from tz_test order by 1;
select id, tstz, tsltz, nullif(tstz, tsltz) from tz_test order by 1;

select id, ts, nvl2(ts, ts+3600, tstz-3600*24) rs from tz_test order by 1;
select id, tsltz, nvl2(tsltz, tsltz+3600*24*2, tstz-3600) rs from tz_test order by 1;
--[er] data overflow
select id, tsltz, nvl2(tsltz, tsltz+3600*24*100, tstz-3600) rs from tz_test order by 1;
select id, ts, nvl2(tstz, tstz-1, (select addtime(tsltz, time'12:00:00 PM') from tz_test where ts=t.ts)) rs from tz_test t order by 1;



drop table tz_test;


set timezone 'Asia/Seoul';
