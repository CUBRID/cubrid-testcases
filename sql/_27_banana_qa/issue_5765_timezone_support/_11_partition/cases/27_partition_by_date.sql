set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(adddate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(adddate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(date(dttz))
(
partition p0 values less than ('03/08/2015'),
partition p1 values less than ('11/08/2015'),
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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(date(dtltz))
(
partition p0 values less than ('03/08/2015'),
partition p1 values less than ('11/08/2015'),
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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(date(tstz))
(
partition p0 values less than ('03/08/2015'),
partition p1 values less than ('11/08/2015'),
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
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York');

alter table t partition by range(date(tsltz))
(
partition p0 values less than ('03/08/2015'),
partition p1 values less than ('11/08/2015'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


drop table if exists t;
set timezone 'Asia/Seoul';


