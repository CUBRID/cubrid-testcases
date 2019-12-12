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

alter table t partition by range(to_datetime_tz(j))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
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

alter table t partition by range(to_datetime_tz(dttz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
partition p2 values less than maxvalue
);


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

alter table t partition by range(to_datetime_tz(dtltz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
partition p2 values less than maxvalue
);

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

alter table t partition by range(to_datetime_tz(tstz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
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

alter table t partition by range(to_datetime_tz(tsltz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimeltz'2015-3-8 01:59:59',timestamptz'2015-3-8 01:59:59',timestampltz'2015-3-8 01:59:59');
alter table t partition by range(to_datetime(dttz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
partition p2 values less than maxvalue
);


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
(null,'2015-3-8 01:59:59','2015-3-8 01:59:59','2015-3-8 01:59:59','2015-3-8 01:59:59','2015-3-8 01:59:59');
alter table t partition by range(to_datetime(dtltz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
partition p2 values less than maxvalue
);



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
(null,'2015-3-8 01:59:59','2015-3-8 01:59:59','2015-3-8 01:59:59','2015-3-8 01:59:59','2015-3-8 01:59:59');
alter table t partition by range(to_datetime(tstz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
partition p2 values less than maxvalue
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');


alter table t partition by range(to_datetime(tsltz))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59'),
partition p1 values less than (timestamptz'2015-11-1 01:59:59 America/New_York'),
partition p2 values less than maxvalue
);
drop table if exists t;
set timezone 'Asia/Seoul';


