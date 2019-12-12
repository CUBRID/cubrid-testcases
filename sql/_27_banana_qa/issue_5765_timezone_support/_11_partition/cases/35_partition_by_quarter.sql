set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(quarter(j))
(
partition p0 values less than (2),
partition p1 values less than (3),
partition p2 values less than maxvalue
);
insert into t(j)values(adddate(datetimeltz'2010-5-4 23:59:59 -3:00',interval '3:00:01' hour_second));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(quarter(j))
(
partition p0 values less than (2),
partition p1 values less than (3),
partition p2 values less than maxvalue
);
insert into t(j)values(adddate(datetimetz'2010-5-4 23:59:59 -3:00',interval '3:00:01' hour_second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimetz'1999-12-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone '-2:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(quarter(j))
(
partition p0 values less than (2),
partition p1 values less than (3),
partition p2 values less than maxvalue
);
insert into t(j)values(adddate(datetimeltz'2010-5-4 23:59:59 -3:00',interval '3:00:01' hour_second));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(quarter(j))
(
partition p0 values less than (2),
partition p1 values less than (3),
partition p2 values less than maxvalue
);
insert into t(j)values(adddate(datetimetz'2010-5-4 23:59:59 -3:00',interval '3:00:01' hour_second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimetz'1999-12-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';




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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(quarter(dttz))
(
partition p0 values less than (1),
partition p1 values less than (2),
partition p2 values less than (3),
partition p3 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(quarter(dtltz))
(
partition p0 values less than (1),
partition p1 values less than (2),
partition p2 values less than (3),
partition p3 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(quarter(tstz))
(
partition p0 values less than (1),
partition p1 values less than (2),
partition p2 values less than (3),
partition p3 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;


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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(quarter(tsltz))
(
partition p0 values less than (1),
partition p1 values less than (2),
partition p2 values less than (3),
partition p3 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;


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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(quarter(j))
(
partition p0 values less than (1),
partition p1 values less than (2),
partition p2 values less than (3),
partition p3 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';
