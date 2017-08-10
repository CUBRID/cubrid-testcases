set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(makedate(i,277))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(i,j)values(2010,subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(makedate(year(j),277))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(i,j)values(2010,subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval -1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+00:10';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(makedate(year(j),277))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval -1 second));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 second));
insert into t(j)values(subdate(datetimeltz'1999-12-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(makedate(i,277))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(i,j)values(2010,subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(makedate(year(j),277))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(i,j)values(2010,subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval -1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '-2:10';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(makedate(year(j),277))
(
partition p0 values less than ('1970-1-1'),
partition p1 values less than ('2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(adddate(datetimeltz'1969-12-31 23:59:59',interval 10 second));
insert into t(j)values(adddate(datetimeltz'1969-12-31 23:59:59',interval 10 second));
insert into t(j)values(subdate(datetimeltz'1999-12-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

drop table if exists t;
set timezone 'Asia/Seoul';
