set timezone '+10:01';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(week(j))
(
partition p0 values less than (1),
partition p1 values less than (15),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1999-12-31 23:00:00 -3:00',interval 1 second));
insert into t(j)values(subdate(datetimeltz'2010-04-05 23:59:59',interval 1 hour ));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';





set timezone '+10:01';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(week(j))
(
partition p0 values less than (1),
partition p1 values less than (15),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1999-12-31 23:00:00 -3:00',interval 1 second));
insert into t(j)values(subdate(datetimeltz'2010-04-05 23:59:59',interval 1 hour ));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(week(j))
(
partition p0 values less than (1),
partition p1 values less than (15),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1999-12-31 23:00:00 -3:00',interval 1 second));
insert into t(j)values(subdate(datetimeltz'2010-04-05 23:59:59',interval 1 hour ));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';





set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(week(j))
(
partition p0 values less than (1),
partition p1 values less than (15),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1999-12-31 23:00:00 -3:00',interval 1 second));
insert into t(j)values(subdate(datetimeltz'2010-04-05 23:59:59',interval 1 hour ));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';

