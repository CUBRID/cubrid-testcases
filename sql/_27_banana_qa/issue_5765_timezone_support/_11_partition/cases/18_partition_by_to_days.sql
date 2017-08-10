set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone) partition by range(to_days(j))
(
partition p0 values less than (366),
partition p1 values less than (80000),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'0002-1-1 1:00:00');
insert into t values (null,datetimeltz'0002-1-1 1:00:00');
insert into t values (null,datetime'2010-10-04 23:00:00');
insert into t values (null,datetimeltz '2010-10-04 23:00:00 +5');
insert into t values (null,datetimetz '2010-10-04 23:00:00 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1; 
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';




set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone) partition by range(to_days(j))
(
partition p0 values less than (366),
partition p1 values less than (80000),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'0002-1-1 1:00:00');
insert into t values (null,datetimeltz'0002-1-1 1:00:00');
insert into t values (null,datetime'2010-10-04 23:00:00');
insert into t values (null,datetimeltz '2010-10-04 23:00:00 +5');
insert into t values (null,datetimetz '2010-10-04 23:00:00 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone) partition by range(to_days(j))
(
partition p0 values less than (366),
partition p1 values less than (80000),
partition p2 values less than maxvalue
);
insert into t values (null,datetimeltz '2010-10-04 23:00:00 +5');
insert into t values (null,datetimetz '2010-10-04 23:00:00 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1; 
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';




set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone) partition by range(to_days(j))
(
partition p0 values less than (366),
partition p1 values less than (80000),
partition p2 values less than maxvalue
);
insert into t values (null,datetime'2010-10-04 23:00:00');
insert into t values (null,datetimeltz '2010-10-04 23:00:00 +5');
insert into t values (null,datetimetz '2010-10-04 23:00:00 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';

