set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,t datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time, tltz timestamp with local time zone) partition by range(extract(hour from t))
(
partition p0 values less than (12),
partition p1 values less than maxvalue
);
insert into t values(null,datetimetz'2008-12-25 10:30:20',null,null,null,null,null);
insert into t values(null,datetimeltz'2008-12-25 10:30:20 +5',null,null,null,null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,t datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
 tltz timestamp with local time zone) partition by range(extract(hour from dtltz))(
partition p0 values less than (12),
partition p1 values less than maxvalue
);
insert into t values(null,null,datetimetz'2008-12-25 10:30:20',null,null,null,null);
insert into t values(null,null,datetimeltz'2008-12-25 10:30:20 +5',null,null,null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,t datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
 tltz timestamp with local time zone) partition by range(extract(hour from tstz))(
partition p0 values less than (12),
partition p1 values less than maxvalue
);
insert into t values(null,null,null,datetimetz'2008-12-25 10:30:20',null,null,null);
insert into t values(null,null,null,datetimeltz'2008-12-25 10:30:20 +5',null,null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,t datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
 tltz timestamp with local time zone) partition by range(extract(hour from tsltz))(
partition p0 values less than (12),
partition p1 values less than maxvalue
);
insert into t values(null,null,null,null,datetimetz'2008-12-25 10:30:20',null,null);
insert into t values(null,null,null,null,datetimeltz'2008-12-25 10:30:20 +5',null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,t datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
 tltz timestamp with local time zone) partition by range(extract(hour from ttz))(
partition p0 values less than (12),
partition p1 values less than maxvalue
);
insert into t values(null,null,null,null,null,time'10:30:20',null);
insert into t values(null,null,null,null,null,time'13:30:20',null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,t datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
 tltz timestamp with local time zone) partition by range(extract(hour from tltz))(
partition p0 values less than (12),
partition p1 values less than maxvalue
);
insert into t values(null,null,null,null,null,null,datetime'2015-9-17 10:30:20');
insert into t values(null,null,null,null,null,null,datetime'2015-9-17 13:30:20');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';

