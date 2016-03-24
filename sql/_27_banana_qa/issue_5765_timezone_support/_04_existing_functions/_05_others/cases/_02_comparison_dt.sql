--test encryption functions with datetime(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone, gid int);

insert into tz_test values(1, datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', null, 1);
insert into tz_test values(2, null, datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', 3);
insert into tz_test values(3, null, null, datetimetz'1993-12-31 23:00:00.999 America/Asuncion', 1);
insert into tz_test values(4, datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', 2);
insert into tz_test values(5, datetimetz'2015-08-13 14:00:00.999 Antarctica/Mawson', datetimetz'2015-08-13 14:00:00.999 Antarctica/Mawson', null, 3);
insert into tz_test values(6, datetimetz'2023-03-23 18:59:59.999 Asia/Taipei', null, null, 2);
insert into tz_test values(7, datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', 1);
insert into tz_test values(8, null, datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', 3);
insert into tz_test values(9, null, null, null, 2);

--test: comparison functions
select id, ts, coalesce(ts, 1), dtltz, coalesce(dtltz, ts, 1), dttz, coalesce(dtltz, dttz, 1) from tz_test order by 1;

select id, ts, dtltz, decode(ts, dtltz, 'ts=dtltz', dttz, 'ts=dttz', 'default') as rs from tz_test order by 1;
select id, dttz, dtltz, decode(dtltz, (select max(dttz) from tz_test), 'max', dttz, 'dtltz=dttz', 'default') as rs from tz_test order by 1;
select id, ts, dttz, decode(dttz, (select min(dttz) from tz_test), 'min', ts, dttz, 'default') as rs from tz_test order by 1;
--BUG: CUBRIDSUS-16277, csql
select id, dttz, dtltz, decode(dtltz, (select max(dttz) from tz_test), datetimetz'0001-01-01 10:00:00.999 AM', dttz, dtltz, datetimetz'0000-00-00 00:00:00.999') as rs from tz_test order by 1;
--BUG: CUBRIDSUS-17155
select cast(datetimetz'0000-00-00 00:00:00.999' as datetimetz);

select id, ts, dtltz, dttz, greatest(dttz, dtltz, ts) as greatest from tz_test order by 1;

select id, ts, if (year(ts)=2015, 'year 2015', ts) as rs from tz_test order by 1;
select id, dttz, dtltz, if (dttz=dtltz, 'equal', 'not equal') as rs from tz_test order by 1;

select id, ts, dtltz, ifnull(ts, dtltz) rs from tz_test order by 1;
select id, dttz, dtltz, ifnull(dtltz, dttz) rs from tz_test order by 1;

select id, ts, isnull(ts), dtltz, isnull(dtltz), dttz, isnull(dttz) from tz_test order by 1;

select id, ts, dtltz, dttz, least(dttz, dtltz, ts) least from tz_test order by 1;

select id, dttz, ts, nullif(dttz, ts) from tz_test order by 1;
select id, dttz, dtltz, nullif(dttz, dtltz) from tz_test order by 1;

select id, ts, nvl2(ts, ts+3600, dttz-3600*24) rs from tz_test order by 1;
select id, dtltz, nvl2(dtltz, dtltz+3600*24*2, dttz-3600) rs from tz_test order by 1;
--[er] data overflow
select id, dtltz, nvl2(dtltz, dtltz+3600*24*100, dttz-3600) rs from tz_test order by 1;
select id, ts, nvl2(dttz, dttz-1, (select addtime(dtltz, time'12:00:00 PM') from tz_test where ts=t.ts)) rs from tz_test t order by 1;



drop table tz_test;


set timezone 'Asia/Seoul';
