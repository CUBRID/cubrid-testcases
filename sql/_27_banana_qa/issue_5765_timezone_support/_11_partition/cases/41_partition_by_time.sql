set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone) partition by range(time(j))
(
partition p0 values less than ('04:00:00'),
partition p1 values less than ('12:00:00 +10'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone) partition by range(time(j))
(
partition p0 values less than ('04:00:00'),
partition p1 values less than ('12:00:00 +10'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone) partition by range(time(j))
(
partition p0 values less than ('04:00:00'),
partition p1 values less than ('12:00:00 +10'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone) partition by range(time(j))
(
partition p0 values less than ('04:00:00'),
partition p1 values less than ('12:00:00 +10'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(time(dttz))
(
partition p0 values less than ('01:59:59'),
partition p1 values less than ('13:59:59'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(time(dtltz))
(
partition p0 values less than ('01:59:59'),
partition p1 values less than ('13:59:59'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(time(tstz))
(
partition p0 values less than ('01:59:59'),
partition p1 values less than ('13:59:59'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(time(tsltz))
(
partition p0 values less than ('01:59:59'),
partition p1 values less than ('13:59:59'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


drop table if exists t;
set timezone 'Asia/Seoul';

