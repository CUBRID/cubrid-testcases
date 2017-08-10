set timezone 'Asia/Seoul';

drop table if exists t;
create table t(id int, ts timestamp, tstz timestamptz,tsltz timestampltz);
insert into t values(1, null, null, null);
insert into t values(2, timestamp'2000-10-10 0:00:00', timestamptz'2000-10-10 0:00:00 Asia/Seoul', timestampltz'2000-10-10 0:00:00 Asia/Seoul');
--timestamp type
select id, median(ts) over(partition by id) from t;
--timestamptz type
select id, median(tstz) over(partition by id) from t;
--timestampltz type
select id, median(tsltz) over(partition by id) from t;

drop table t;

drop table if exists t;
create table t(id int, dt datetime, dttz datetimetz,dtltz datetimeltz);
insert into t values(1, null, null, null);
insert into t values(2, datetime'2000-10-10 0:00:00', datetimetz'2000-10-10 0:00:00 Asia/Seoul', datetimeltz'2000-10-10 0:00:00 Asia/Seoul');
--datetime type
select id, median(dt) over(partition by id) from t;
--datetimetz type
select id, median(dttz) over(partition by id) from t;
--datetimeltz type
select id, median(dtltz) over(partition by id) from t;

drop table t;
