set timezone '+01:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+01:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone 'America/New_York';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+01:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+01:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone 'America/New_York';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+01:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';



set timezone '+01:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Seoul';

set timezone 'America/New_York';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(maketime(hour(j),34,4))
(
partition p0 values less than (time'9:00:00'),
partition p1 values less than (time'21:00:00'),
partition p2 values less than maxvalue
);
insert into t(j)values(subdate(datetimeltz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(subdate(datetimetz'1969-12-31 23:59:59 -10:00',interval -1 second));
insert into t(j)values(datetimetz'1969-12-31 23:59:59 -10:00');


select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
 





drop table if exists t;
set timezone 'Asia/Seoul';
