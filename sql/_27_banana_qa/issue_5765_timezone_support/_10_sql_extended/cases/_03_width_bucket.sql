set timezone 'Asia/Seoul';
--Test case : datetimetz/datetimeltz
drop table if exists t1;
create table t1 (id int, dtltz DATETIME WITH LOCAL TIME ZONE, dttz DATETIME WITH TIME ZONE);
INSERT INTO t1 VALUES(1, datetimeltz '2003-01-03 2:00:00 +9:00',datetimetz '2003-01-03 2:00:00 +9:00');
INSERT INTO t1 VALUES(2, datetimeltz '2003-01-02 2:00:00 +9:00',datetimetz '2003-01-02 2:00:00 +9:00');
INSERT INTO t1 VALUES(3, datetimeltz '2003-01-01 2:00:00 +9:00',datetimetz '2003-01-01 2:00:00 +9:00');

--CUBRIDSUS-17518
--select id, dtltz, width_bucket(dtltz, datetimeltz'2003-01-01 1:00:00 +9:00',datetimeltz'2003-01-04 1:00:00 +9:00',3) as bucket from t1;
select id, dttz, width_bucket(dttz, datetimetz'2003-01-01 1:00:00 +9:00',datetimetz'2003-01-04 1:00:00 +9:00',3) as bucket from t1 order by id;
drop table t1;

--Test case : timestamptz/timestampltz
drop table if exists t2;
create table t2 (id int, tsltz timestamp WITH LOCAL TIME ZONE,tstz timestamp WITH TIME ZONE);
INSERT INTO t2 VALUES(1, timestampltz'2003-01-03 2:00:00 +9:00',timestamptz'2003-01-01 2:00:00 +9:00');
INSERT INTO t2 VALUES(2, timestampltz'2003-01-02 2:00:00 +9:00',timestamptz'2003-01-02 2:00:00 +9:00');
INSERT INTO t2 VALUES(3, timestampltz'2003-01-01 2:00:00 +9:00',timestamptz'2003-01-03 2:00:00 +9:00');

select id, tsltz,width_bucket(tsltz, timestampltz'2003-01-01 1:00:00 +9:00',timestampltz'2003-01-04 1:00:00 +9:00',3) as bucket from t2 order by id;
select id, tstz,width_bucket(tstz, timestamptz'2003-01-01 1:00:00 +9:00',timestamptz'2003-01-04 1:00:00 +9:00',3) as bucket from t2 order by id;
drop table t2;



