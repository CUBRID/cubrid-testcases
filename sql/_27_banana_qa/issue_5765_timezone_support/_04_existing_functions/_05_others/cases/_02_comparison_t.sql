--test encryption functions with time(l)tz types

set timezone '+9:00';

drop table if exists tz_test;

create table tz_test(id int primary key, ts timestamp, tltz timestamp with local time zone, ttz timestamp with time zone, gid int);

insert into tz_test values(1, timestamptz'2015-9-20 00:00:00 America/Regina', timestamptz'2015-9-20 00:00:00 America/Regina', null, 1);
insert into tz_test values(2, null, timestamptz'2015-9-20 5:00:00 Europe/Minsk', timestamptz'2015-9-20 5:00:00 Europe/Minsk', 3);
insert into tz_test values(3, null, null, timestamptz'2015-9-20 23:00:00 Atlantic/South_Georgia', 1);
insert into tz_test values(4, timestamptz'2015-9-20 8:00:00 Indian/Cocos', timestamptz'2015-9-20 8:00:00 Indian/Cocos', timestamptz'2015-9-20 8:00:00 Indian/Cocos', 2);
insert into tz_test values(5, timestamptz'2015-9-20 14:00:00 Antarctica/Mawson', timestamptz'2015-9-20 14:00:00 Antarctica/Mawson', null, 3);
insert into tz_test values(6, timestamptz'2015-9-20 18:59:59 Asia/Taipei', null, null, 2);
insert into tz_test values(7, timestamptz'2015-9-20 21:30:56 Africa/Maputo', timestamptz'2015-9-20 21:30:56 Africa/Maputo', timestamptz'2015-9-20 21:30:56 Africa/Maputo', 1);
insert into tz_test values(8, null, timestamptz'2015-9-20 17:29:34 Africa/Algiers', timestamptz'2015-9-20 17:29:34 Africa/Algiers', 3);
insert into tz_test values(9, null, null, null, 2);

--test: comparison functions
select id, ts, coalesce(ts, 1), tltz, coalesce(tltz, ts, 1), ttz, coalesce(tltz, ttz, 1) from tz_test order by 1;

select id, ts, tltz, decode(ts, tltz, 'ts=tltz', ttz, 'ts=ttz', 'default') as rs from tz_test order by 1;
select id, ttz, tltz, decode(tltz, (select max(ttz) from tz_test), 'max', ttz, 'tltz=ttz', 'default') as rs from tz_test order by 1;
select id, ts, ttz, decode(ttz, (select min(ttz) from tz_test), 'min', ts, 'ts=ttz', 'default') as rs from tz_test order by 1;
select id, ttz, tltz, decode(tltz, (select max(ttz) from tz_test), timestamptz'2015-9-20 10:00:00 AM', ttz, tltz, timestamptz'2015-9-20 00:00:00') as rs from tz_test order by 1;
select cast(timestamptz'2015-9-20 00:00:00' as timestampltz);

select id, ts, tltz, ttz, greatest(ttz, tltz, ts) as greatest from tz_test order by 1;

select id, ts, if (year(ts)=2015, 'year 2015', ts) as rs from tz_test order by 1;
select id, ttz, tltz, if (ttz=tltz, 'equal', 'not equal') as rs from tz_test order by 1;

select id, ts, tltz, ifnull(ts, tltz) rs from tz_test order by 1;
select id, ttz, tltz, ifnull(tltz, ttz) rs from tz_test order by 1;

select id, ts, isnull(ts), tltz, isnull(tltz), ttz, isnull(ttz) from tz_test order by 1;

select id, ts, tltz, ttz, least(ttz, tltz, ts) least from tz_test order by 1;

select id, ttz, ts, nullif(ttz, ts) from tz_test order by 1;
select id, ttz, tltz, nullif(ttz, tltz) from tz_test order by 1;

select id, ts, nvl2(ts, ts+3600, ttz-3600*24) rs from tz_test order by 1;
select id, tltz, nvl2(tltz, tltz+3600*24*2, ttz-3600) rs from tz_test order by 1;
select id, tltz, nvl2(tltz, tltz+3600*24*100, ttz-3600) rs from tz_test order by 1;
select id, ts, nvl2(ttz, ttz-1, (select addtime(tltz, time'2:00:00 AM') from tz_test where ts=t.ts)) rs from tz_test t order by 1;



drop table tz_test;


set timezone 'Asia/Seoul';
