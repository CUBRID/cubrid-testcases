set timezone 'Asia/Seoul';

drop table if exists t;
create table t(tstz timestamp with time zone);
insert into t values(timestamptz'2005-04-01 1:00:00 Asia/Seoul');
select median(tstz) from t;
select typeof(median(tstz)) from t;
drop table t;

drop table if exists t;
create table t(tsltz timestamp with local time zone);
insert into t values(timestampltz'2005-04-01 1:00:00 Asia/Seoul');
select median(tsltz) from t;
select typeof(median(tsltz)) from t;
drop table t;

drop table if exists t;
create table t(dttz datetime with time zone);
insert into t values(datetimetz'2005-04-01 1:00:00 Asia/Seoul');
select median(dttz) from t;
select typeof(median(dttz)) from t;
drop table t;

drop table if exists t;
create table t(dtltz datetime with local time zone);
insert into t values(datetimeltz'2005-04-01 1:00:00 Asia/Seoul');
select median(dtltz) from t;
select typeof(median(dtltz)) from t;
drop table t;

