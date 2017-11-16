--test set operators with DATETIME(L)TZ columns
set system parameters 'tz_leap_second_support=yes';


drop table if exists t1, t2;

create table t1(id int, ts datetime, dtltz datetime with local time zone);
create table t2(id int, dttz datetime with time zone);

set timezone 'Asia/Seoul';

--duplicate rows
insert into t1 values(1, '2003-2-28 18:00:05.999', '2003-2-28 18:00:05.999');
insert into t2 values(1, '2003-2-28 18:00:05.999 +9:00');

insert into t1 values(1, '2003-2-28 18:00:05.999 Asia/Pyongyang', '2003-2-28 18:00:05.999 Asia/Pyongyang');
insert into t2 values(1, '2003-2-28 17:00:05.999 Asia/Chongqing');

--duplicate rows, DST
insert into t1 values(2, datetimetz'1987-5-10 1:59:59.999'+1, datetimeltz'1987-5-10 1:59:59.999 Asia/Seoul'+1);
insert into t2 values(2, datetimetz'1987-5-10 1:59:59.999 +9:00'+1);

set timezone 'UTC';
insert into t1 values(3, datetimetz'1988-10-08 18:00:00.999 +1:00'-1, datetimeltz'1988-10-08 18:00:00.999 +1:00'-1);
insert into t2 values(3, datetimetz'1988-10-09 3:00:00.999 AM +9:00'-1);

--duplicate rows, leap seconds
insert into t1 values(4, datetime'1987-12-31 23:59:59.999'+1, datetimeltz'1987-12-31 23:59:59.999');
insert into t2 values(4, datetimetz'1987-12-31 23:59:59.999'+1);

--different rows
insert into t1 values(5, datetimeltz'1987-7-1 08:30:00.999 Asia/Seoul', '1987-7-1 08:30:00.999 Asia/Seoul');
insert into t2 values(6, '1987-7-1 08:30:00.999 +9:00');

set timezone 'Asia/Seoul';
--test: union, ts+dttz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, ts from t1 union all select id, dttz as ts from t2 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dttz as ts from t2 union select id, ts from t1 order by 1, 2) order by 1,2;
--test: union, dtltz+dttz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dtltz as ts from t1 union all select id, dttz as ts from t2 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dttz as ts from t2 union select id, dtltz as ts from t1 order by 1, 2) order by 1,2;



--test: union, ts+dtltz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 union all select id, dtltz as ts from t1 where id=1 order by 1, 2);
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, dtltz as ts from t1 union select id, ts from t1 where id<5 order by 1, 2);

--test: difference, ts+dttz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, ts from t1 where id<10 difference select id, dttz as ts from t2 order by 1, 2);
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dttz as ts from t2 difference select id, ts from t1 order by 1, 2);
--test: difference, dtltz+dttz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dtltz as ts from t1 difference select id, dttz as ts from t2 order by 1, 2);
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dttz as ts from t2 difference select id, dtltz as ts from t1 order by 1, 2);
--test: difference, ts+dtltz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 where id>2 difference select id, dtltz as ts from t1 order by 1, 2);
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, dtltz as ts from t1 difference select id, ts from t1 where id>2 order by 1, 2);

--test: intersect, ts+dttz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, ts from t1 where id<10 intersect select id, dttz as ts from t2 order by 1, 2);
--test: intersect, dtltz+dttz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS.FF TZR TZD') from (select id, dttz as ts from t2 intersect select id, dtltz as ts from t1 order by 1, 2);
--test: intersect, dtltz+ts
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 intersect select id, dtltz as ts from t1 order by 1, 2);


drop table t1, t2;

set timezone 'Asia/Seoul';




set system parameters 'tz_leap_second_support=no';
