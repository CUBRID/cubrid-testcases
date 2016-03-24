set timezone 'Asia/Seoul';

drop table if exists t1;
create table t1 (id int, dtltz DATETIME WITH LOCAL TIME ZONE);
INSERT INTO t1 VALUES(1, datetimeltz '2003-01-03 2:00:00 +9:00');
INSERT INTO t1 VALUES(2, datetimeltz '2003-01-02 2:00:00 +9:00');
INSERT INTO t1 VALUES(3, datetimeltz '2003-01-01 2:00:00 +9:00');

select id, dtltz, width_bucket(dtltz, datetimeltz'2003-01-01 1:00:00 +9:00',datetimeltz'2003-01-04 1:00:00 +9:00',3) as bucket from t1;  

select id, dtltz, width_bucket(dtltz, datetimetz'2003-01-01 1:00:00 +9:00',datetimetz'2003-01-04 1:00:00 +9:00',3) as bucket from t1;

drop table t1;

drop table if exists t1;
create table t1 (id int, tsltz TIMESTAMP WITH LOCAL TIME ZONE);
INSERT INTO t1 VALUES(1, timestampltz '2003-01-03 2:00:00 +9:00');
INSERT INTO t1 VALUES(2, timestampltz '2003-01-02 2:00:00 +9:00');
INSERT INTO t1 VALUES(3, timestampltz '2003-01-01 2:00:00 +9:00');

select id, tsltz, width_bucket(tsltz, timestampltz'2003-01-01 1:00:00 +9:00',timestampltz'2003-01-04 1:00:00 +9:00',3) as bucket from t1;

select id, tsltz, width_bucket(tsltz, timestamptz'2003-01-01 1:00:00 +9:00',timestamptz'2003-01-04 1:00:00 +9:00',3) as bucket from t1;

drop table t1;
