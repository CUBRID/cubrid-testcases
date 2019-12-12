set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (10),
partition p2 values less than (15),
partition p3 values less than (20),
partition p4 values less than (25),
partition p5 values less than (32)
);
insert into t(j,k)values('1500-1-5 00:00:00','16th century');
insert into t(j,k)values('1600-1-10 00:00:00','17th century');
insert into t(j,k)values('1700-1-15 00:00:00','18th century');
insert into t(j,k)values('1800-1-20 00:00:00','19th century');
insert into t(j,k)values('1900-1-25 00:00:00','20th century');
insert into t(j,k)values('2000-1-1 00:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3 order by 1;
select * from t__p__p4 order by 1;
select * from t__p__p5 order by 1;



set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (10),
partition p2 values less than (15),
partition p3 values less than (20),
partition p4 values less than (25),
partition p5 values less than (32)
);
insert into t(j,k)values('1500-1-5 00:00:00','16th century');
insert into t(j,k)values('1600-1-10 00:00:00','17th century');
insert into t(j,k)values('1700-1-15 00:00:00','18th century');
insert into t(j,k)values('1800-1-20 00:00:00','19th century');
insert into t(j,k)values('1900-1-25 00:00:00','20th century');
insert into t(j,k)values('2000-1-1 00:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3 order by 1;
select * from t__p__p4 order by 1;
select * from t__p__p5 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (10),
partition p2 values less than (15),
partition p3 values less than (20),
partition p4 values less than (25),
partition p5 values less than (32)
);
set timezone '+04:00';
insert into t(j,k)values('1500-1-1 00:00:00','16th century');
insert into t(j,k)values('1600-1-1 00:00:00','17th century');
insert into t(j,k)values('1700-1-1 00:00:00','18th century');
insert into t(j,k)values('1800-1-1 00:00:00','19th century');
insert into t(j,k)values('1900-1-1 00:00:00','20th century');
insert into t(j,k)values('2000-1-1 00:00:00','21th century');

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (10),
partition p2 values less than (15),
partition p3 values less than (20),
partition p4 values less than (25),
partition p5 values less than (32)
);
set timezone '+04:00';
insert into t(j,k)values('1500-1-1 00:00:00','16th century');
insert into t(j,k)values('1600-1-1 00:00:00','17th century');
insert into t(j,k)values('1700-1-1 00:00:00','18th century');
insert into t(j,k)values('1800-1-1 00:00:00','19th century');
insert into t(j,k)values('1900-1-1 00:00:00','20th century');
insert into t(j,k)values('2000-1-1 00:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3 order by 1;
select * from t__p__p4 order by 1;
select * from t__p__p5 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (10),
partition p2 values less than (15),
partition p3 values less than (20),
partition p4 values less than (25),
partition p5 values less than (32)
);
--set timezone '+04:00';
insert into t(j,k)values('1500-1-1 00:00:00 +05:00','16th century');
insert into t(j,k)values('1600-1-1 00:00:00 +05:00','17th century');
insert into t(j,k)values('1700-1-1 00:00:00 +05:00','18th century');
insert into t(j,k)values('1800-1-1 00:00:00 +05:00','19th century');
insert into t(j,k)values('1900-1-1 00:00:00 +05:00','20th century');
insert into t(j,k)values('2000-1-1 00:00:00 +05:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3 order by 1;
select * from t__p__p4 order by 1;
select * from t__p__p5 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (2),
partition p1 values less than maxvalue

);
--set timezone '+04:00';
insert into t(j,k)values('1500-1-1 00:00:00 +09:00 ','16th century');
insert into t(j,k)values('1600-1-1 00:00:00 +09:00 ','17th century');
insert into t(j,k)values('1700-1-1 00:00:00 +09:00 ','18th century');
insert into t(j,k)values('1800-1-1 00:00:00 +09:00 ','19th century');
insert into t(j,k)values('1900-1-1 00:00:00 +09:00 ','20th century');
insert into t(j,k)values('2000-1-1 00:00:00 +09:00 ','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (3),
partition p2 values less than (4),
partition p3 values less than maxvalue
);
set timezone '+04:00';
insert into t(j,k)values('1500-1-1 00:00:00 +09:00 ','16th century');
set timezone '+05:00';
insert into t(j,k)values('1600-1-1 00:00:00 ','17th century');
set timezone '+06:00';
insert into t(j,k)values('1700-1-1 00:00:00 ','18th century');
set timezone '+07:00';
insert into t(j,k)values('1800-1-1 00:00:00 ','19th century');
set timezone '+08:00';
insert into t(j,k)values('1900-1-1 00:00:00  ','20th century');
set timezone '+09:00';
insert into t(j,k)values('2000-1-1 00:00:00  ','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3 order by 1;



set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (year(datetimeltz'1500-1-1 00:00:00')),
partition p1 values less than (year(datetimeltz'1600-1-1 00:00:00')),
partition p2 values less than (year(datetimeltz'1700-1-1 00:00:00')),
partition p3 values less than (year(datetimeltz'1800-1-1 00:00:00')),
partition p4 values less than (year(datetimeltz'1900-1-1 00:00:00')),
partition p5 values less than (year(datetimeltz'2000-1-1 00:00:00'))
);
--set timezone '+04:00';
insert into t(j,k)values('1500-1-1 00:00:00 +05:00','16th century');

set timezone '+01:01';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (32)
);
insert into t(j,k)values('2000-1-1 00:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (32)
);
insert into t(j,k)values('2000-1-1 00:00:00 +5:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (32)
);
insert into t(j,k)values('2000-1-1 00:00:00 +5:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (32)
);
set timezone '+04:00';
insert into t(j,k)values('2000-1-1 00:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp,k varchar(20)) partition  by range(day(j))
(
partition p0 values less than (5),
partition p1 values less than (32)
);
set timezone '+04:00';
insert into t(j,k)values('2000-1-1 00:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(month(j))
(
partition p0 values less than (2),
partition p1 values less than maxvalue

);
insert into t(j,k)values('2000-1-1 00:00:00 ','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


set timezone '+3:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(day(j))
(
partition p5 values less than (year(datetimeltz'2000-1-1 00:00:00'))
);
insert into t(j,k)values('2000-1-1 00:00:00 +05:00','21th century');
drop table if exists t;
set timezone 'Asia/Seoul';

