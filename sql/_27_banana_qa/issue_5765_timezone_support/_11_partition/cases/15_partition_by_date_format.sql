set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(date_format(j,'%H'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 -8:00',interval 3 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;


drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(date_format(j,'%H'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 -8:00',interval 3 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(date_format(j,'%H'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 +8:00',interval 3 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(date_format(j,'%H'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 +8:00',interval 3 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';




set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 -8:00',interval 3 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;


drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 -8:00',interval 3 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 +8:00',interval 3 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 +8:00',interval 3 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 -8:00',interval 3 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;


drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 -8:00',interval 3 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 +8:00',interval 3 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(date_format(j,'%W %M %Y %H:%i:%s'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:00:00 +8:00',interval 3 hour));
select * from t__p__p1 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 13:00:00 +09',interval 2 hour));
select * from t__p__p0 order by 1;
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';





