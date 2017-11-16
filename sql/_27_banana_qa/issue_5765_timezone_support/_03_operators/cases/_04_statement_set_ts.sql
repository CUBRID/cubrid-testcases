--test set operators with TIMESTAMP(L)TZ columns
set system parameters 'tz_leap_second_support=yes';


drop table if exists t1, t2;

create table t1(id int, ts timestamp, tsltz timestamp with local time zone);
create table t2(id int, tstz timestamp with time zone);

set timezone 'Asia/Seoul';

--duplicate rows
insert into t1 values(1, '2003-2-28 18:00:05', '2003-2-28 18:00:05');
insert into t2 values(1, '2003-2-28 18:00:05 +9:00');

insert into t1 values(1, '2003-2-28 18:00:05 Asia/Pyongyang', '2003-2-28 18:00:05 Asia/Pyongyang');
insert into t2 values(1, '2003-2-28 17:00:05 Asia/Chongqing');

--duplicate rows, DST
insert into t1 values(2, timestamptz'1987-5-10 1:59:59'+1, timestampltz'1987-5-10 1:59:59 Asia/Seoul'+1);
insert into t2 values(2, timestamptz'1987-5-10 1:59:59 +9:00'+1);

set timezone 'UTC';
insert into t1 values(3, timestamptz'1988-10-08 19:00:00 +1:00'-1, timestampltz'1988-10-08 19:00:00 +1:00'-1);
insert into t2 values(3, timestamptz'1988-10-9 3:00:00 AM +9:00'-1);

--duplicate rows, leap seconds
insert into t1 values(4, timestamp'1987-12-31 23:59:59'+1, timestampltz'1987-12-31 23:59:59');
insert into t2 values(4, timestamptz'1987-12-31 23:59:59'+1);

--different rows
insert into t1 values(5, timestampltz'1987-7-1 08:30:00 Asia/Seoul', '1987-7-1 08:30:00 Asia/Seoul');
insert into t2 values(6, '1987-7-1 08:30:00 +9:00');

set timezone 'Asia/Seoul';
--test: union, ts+tstz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 union all select id, tstz as ts from t2 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tstz as ts from t2 union select id, ts from t1 order by 1, 2) order by 1,2;
--test: union, tsltz+tstz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tsltz as ts from t1 union all select id, tstz as ts from t2 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tstz as ts from t2 union select id, tsltz as ts from t1 order by 1, 2) order by 1,2;
--test: union, ts+tsltz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 union all select id, tsltz as ts from t1 where id=1 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tsltz as ts from t1 union select id, ts from t1 where id<5 order by 1, 2) order by 1,2;

--test: difference, ts+tstz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 where id<10 difference select id, tstz as ts from t2 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tstz as ts from t2 difference select id, ts from t1 order by 1, 2) order by 1,2;
--test: difference, tsltz+tstz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tsltz as ts from t1 difference select id, tstz as ts from t2 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tstz as ts from t2 difference select id, tsltz as ts from t1 order by 1, 2) order by 1,2;
--test: difference, ts+tsltz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 where id>2 difference select id, tsltz as ts from t1 order by 1, 2) order by 1,2;
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tsltz as ts from t1 difference select id, ts from t1 where id>2 order by 1, 2) order by 1,2;

--test: intersect, ts+tstz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 where id<10 intersect select id, tstz as ts from t2 order by 1, 2) order by 1,2;
--test: intersect, tsltz+tstz
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, tstz as ts from t2 intersect select id, tsltz as ts from t1 order by 1, 2) order by 1,2;
--test: intersect, tsltz+ts
select id,to_char(ts,'YYYY-MM-DD HH24:MI:SS TZR TZD') from (select id, ts from t1 intersect select id, tsltz as ts from t1 order by 1, 2) order by 1,2;


drop table t1, t2;

set timezone 'Asia/Seoul';




set system parameters 'tz_leap_second_support=no';
