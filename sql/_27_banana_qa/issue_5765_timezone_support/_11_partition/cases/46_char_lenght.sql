set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(char_length(j))
(
partition p0 values less than (3),
partition p1 values less than (7),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 second ));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetimeltz'2015-1-1 23:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';


set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(char_length(j))
(
partition p0 values less than (3),
partition p1 values less than (7),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 second ));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetimeltz'2015-1-1 23:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(char_length(j))
(
partition p0 values less than (3),
partition p1 values less than (7),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 second ));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetimeltz'2015-1-1 23:59:59',interval 2 hour));
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';


set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(char_length(j))
(
partition p0 values less than (3),
partition p1 values less than (7),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
insert into t(j)values(subdate(datetimeltz'2014-12-31 23:59:59',interval 1 second ));
select * from t__p__p1 order by 1;
insert into t(j)values(adddate(datetimeltz'2015-1-1 23:59:59',interval 2 hour));
select * from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';
