set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('01/01/1970'),
partition p1 values less than ('01/01/2000'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';






set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('01/01/1970'),
partition p1 values less than ('01/01/2000'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
drop table if exists t;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('01/01/1970'),
partition p1 values less than ('01/01/2000'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(adddate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(date(j))
(
partition p0 values less than ('01/01/1970'),
partition p1 values less than ('01/01/2000'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -3:00',interval 1 millisecond));
insert into t(j)values(adddate(datetimeltz'1969-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-12-31 23:59:59',interval 1 millisecond));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';
