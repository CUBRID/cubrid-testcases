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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(dayofmonth(dttz))
(
partition p0 values less than (1),
partition p1 values less than (8),
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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(dayofmonth(dtltz))
(
partition p0 values less than (1),
partition p1 values less than (8),
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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(dayofmonth(tstz))
(
partition p0 values less than (1),
partition p1 values less than (8),
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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(dayofmonth(tsltz))
(
partition p0 values less than (1),
partition p1 values less than (8),
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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(dayofmonth(j))
(
partition p0 values less than (1),
partition p1 values less than (8),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';
