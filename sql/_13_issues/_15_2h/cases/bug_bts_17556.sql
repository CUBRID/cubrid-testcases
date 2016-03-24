set timezone 'Asia/Seoul';

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 (id int, dtltz datetimeltz);
insert into t1 values(1,'12:00:00.000 PM 04/30/1990 +9:00');
SELECT dtltz from t1;
SELECT dtltz, UNIX_TIMESTAMP(dtltz) from t1;

create table t2 (id int, dttz datetimetz);
insert into t2 values(1,'12:00:00.000 PM 04/30/1990 +9:00');
SELECT dttz from t2;
SELECT dttz, UNIX_TIMESTAMP(dttz) from t2;

create table t3 (id int, dt datetime);
insert into t3 values(1,'12:00:00.000 PM 04/30/1990');
SELECT dt from t3;
SELECT dt, UNIX_TIMESTAMP(dt) from t3;

drop table t1,t2,t3;

set timezone 'Asia/Seoul';
