set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(time_format(j,'%h:%i:%s %p'))
(
partition p0 values less than ('12:00:00'),
partition p1 values less than maxvalue
);
insert into t(j)values(datetimeltz'2014-12-31 23:00:00 +8:00');
insert into t(j)values(datetimeltz'2014-12-31 13:00:00 +09');
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(time_format(j,'%h:%i:%s %p'))
(
partition p0 values less than ('11:00:00'),
partition p1 values less than maxvalue
);
insert into t(j)values(datetimeltz'2014-12-31 23:00:00 +6:00');
insert into t(j)values(datetimeltz'2014-12-31 13:00:00 +09');
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(time_format(j,'%h:%i:%s %p'))
(
partition p0 values less than ('12:00:00'),
partition p1 values less than maxvalue
);
insert into t(j)values(datetimeltz'2014-12-31 23:00:00 +8:00');
insert into t(j)values(datetimeltz'2014-12-31 13:00:00 +09');
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(time_format(j,'%h:%i:%s %p'))
(
partition p0 values less than ('11:00:00'),
partition p1 values less than maxvalue
);
insert into t(j)values(datetimeltz'2014-12-31 23:00:00 +6:00');
insert into t(j)values(datetimeltz'2014-12-31 13:00:00 +09');
insert into t(j)values(adddate(datetime'2015-1-1 19:59:59',interval 2 hour));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


drop table if exists t;
set timezone 'Asia/Seoul';



