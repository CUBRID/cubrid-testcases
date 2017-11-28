--test set operators with TIME(L)TZ columns


drop table if exists t1, t2;

create table t1(id int, t datetime, dtltz datetime with local time zone);
create table t2(id int, dttz datetime with time zone);

set timezone '+9:00';

--duplicate rows
insert into t1 values(1, '2015-9-17 18:00:05', '2015-9-17 18:00:05');
insert into t2 values(1, '2015-9-17 18:00:05 +9:00');

insert into t1 values(1, datetimetz'2015-9-17 18:00:05 Asia/Pyongyang', datetimetz'2015-9-17 18:00:05 Asia/Pyongyang');
insert into t2 values(1, '2015-9-17 17:00:05 Asia/Chongqing');

--duplicate rows
insert into t1 values(2, datetimetz'2015-9-17 23:59:59'+1, datetimetz'2015-9-17 23:59:59 Asia/Seoul'+1);
insert into t2 values(2, datetimetz'2015-9-17 23:59:59 +9:00'+1);

set timezone '+00:00';
insert into t1 values(3, datetimetz'2015-9-17 15:00:00 +1:00'-1, datetimeltz'2015-9-17 15:00:00 +1:00'-1);
insert into t2 values(3, datetimetz'2015-9-17 12:00:00 AM +9:00'-1);

--duplicate rows
insert into t1 values(4, datetime'2015-9-17 23:59:59', datetimetz'2015-9-17 23:59:59');
insert into t2 values(4, datetimetz'2015-9-17 23:59:59');

--different rows
insert into t1 values(5, datetimeltz'2015-9-17 08:30:00 +10:00', '2015-9-17 08:30:00 +10:00');
insert into t2 values(6, '2015-9-17 08:30:00 +9:00');

set timezone '+9:00';
--test: union, t+dttz
select id, t, to_char(t) from t1 union all select id, dttz, to_char(dttz) from t2 order by 1, 2, 3;
select id, dttz as t from (select id,dttz,to_char(dttz) from t2 order by 1,3 desc) union select id, t from t1 order by 1, 2;
--test: union, dtltz+dttz
select id, dtltz as t, to_char(dtltz) from t1 union all select id, dttz as t , to_char(dttz) from t2 order by 1, 2, 3;
--select id, dttz as t from t2 union select id, dtltz as t from t1 order by 1, 2;
--test: union, t+dtltz
select id, t from t1 union all select id, dtltz as t from t1 where id=1 order by 1, 2;
--select id, dtltz as t from t1 union select id, t from t1 where id<5 order by 1, 2;

--test: difference, t+dttz
select id, t from t1 where id<10 difference select id, dttz as t from t2 order by 1, 2;
select id, dttz as t from t2 difference select id, t from t1 order by 1, 2;
--test: difference, dtltz+dttz
--select id, dtltz as t from t1 difference select id, dttz as t from t2 order by 1, 2;
--select id, dttz as t from t2 difference select id, dtltz as t from t1 order by 1, 2;
--test: difference, t+dtltz
select id, t from t1 where id>2 difference select id, dtltz as t from t1 order by 1, 2;
select id, dtltz as t from t1 difference select id, t from t1 where id>2 order by 1, 2;

--test: intersect, t+dttz
select id, t from t1 where id<10 intersect select id, dttz as t from t2 order by 1, 2;
--test: intersect, dtltz+dttz
--select id, dttz as t from t2 intersect select id, dtltz as t from t1 order by 1, 2;
--test: intersect, dtltz+t
select id, t from t1 intersect select id, dtltz as t from t1 order by 1, 2;


drop table t1, t2;

set timezone 'Asia/Seoul';

