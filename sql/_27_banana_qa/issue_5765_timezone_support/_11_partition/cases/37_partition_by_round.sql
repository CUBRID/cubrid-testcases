set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(round(j,'mm'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(round(j,'mm'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimetz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimetz'2012-1-1 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(round(j,'yyyy'))
(
partition p0 values less than (date'2011-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimetz'2011-12-31 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(round(j,'dd'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimetz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimetz'2012-1-1 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(round(j,'mm'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(round(j,'mm'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimetz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimetz'2012-1-1 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(round(j,'yyyy'))
(
partition p0 values less than (date'2011-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimetz'2011-12-31 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(round(j,'dd'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimetz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimetz'2012-1-1 23:00:00 -8:00');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';

