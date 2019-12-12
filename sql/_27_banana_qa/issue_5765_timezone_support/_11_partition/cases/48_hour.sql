set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
insert into t(j,k)values('1500-1-1 00:00:00','16th century');
insert into t(j,k)values('1600-1-1 01:00:00','17th century');
insert into t(j,k)values('1700-1-1 02:00:00','18th century');
insert into t(j,k)values('1800-1-1 03:00:00','19th century');
insert into t(j,k)values('1900-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
set timezone '+02:00';
insert into t(j,k)values('1500-1-1 00:00:00','16th century');
insert into t(j,k)values('1600-1-1 01:00:00','17th century');
insert into t(j,k)values('1700-1-1 02:00:00','18th century');
insert into t(j,k)values('1800-1-1 03:00:00','19th century');
insert into t(j,k)values('1900-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
set timezone '+02:00';
insert into t(j,k)values('1500-1-1 00:00:00','16th century');
set timezone '+03:00';
insert into t(j,k)values('1600-1-1 01:00:00','17th century');
set timezone '+04:00';
insert into t(j,k)values('1700-1-1 02:00:00','18th century');
insert into t(j,k)values('1800-1-1 03:00:00','19th century');
insert into t(j,k)values('1900-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
set timezone 'Asia/Shanghai';
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
set timezone 'Asia/Seoul';
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
set timezone 'America/New_York';
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
set timezone '+02:00';
insert into t(j,k)values('1500-1-1 00:00:00','16th century');
insert into t(j,k)values('1600-1-1 01:00:00','17th century');
insert into t(j,k)values('1700-1-1 02:00:00','18th century');
insert into t(j,k)values('1800-1-1 03:00:00','19th century');
insert into t(j,k)values('1900-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
insert into t(j,k)values('1500-1-1 00:00:00 +02:00','16th century');
insert into t(j,k)values('1600-1-1 01:00:00 +02:00','17th century');
insert into t(j,k)values('1700-1-1 02:00:00 +02:00','18th century');
insert into t(j,k)values('1800-1-1 03:00:00 +02:00','19th century');
insert into t(j,k)values('1900-1-1 04:00:00 +02:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

drop table if exists t;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
insert into t(j,k)values('2005-1-1 00:00:00','16th century');
insert into t(j,k)values('2006-1-1 01:00:00','17th century');
insert into t(j,k)values('2007-1-1 02:00:00','18th century');
insert into t(j,k)values('2008-1-1 03:00:00','19th century');
insert into t(j,k)values('2009-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
set timezone '+02:00';
insert into t(j,k)values('2005-1-1 00:00:00','16th century');
insert into t(j,k)values('2006-1-1 01:00:00','17th century');
insert into t(j,k)values('2007-1-1 02:00:00','18th century');
insert into t(j,k)values('2008-1-1 03:00:00','19th century');
insert into t(j,k)values('2009-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
set timezone '+02:00';
insert into t(j,k)values('2005-1-1 00:00:00','16th century');
set timezone '+03:00';
insert into t(j,k)values('2006-1-1 01:00:00','17th century');
set timezone '+04:00';
insert into t(j,k)values('2007-1-1 02:00:00','18th century');
insert into t(j,k)values('2008-1-1 03:00:00','19th century');
insert into t(j,k)values('2009-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
set timezone 'Asia/Shanghai';
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
set timezone 'Asia/Seoul';
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
set timezone 'America/New_York';
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
set timezone '+02:00';
insert into t(j,k)values('2005-1-1 00:00:00','16th century');
insert into t(j,k)values('2006-1-1 01:00:00','17th century');
insert into t(j,k)values('2007-1-1 02:00:00','18th century');
insert into t(j,k)values('2008-1-1 03:00:00','19th century');
insert into t(j,k)values('2009-1-1 04:00:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(hour(j))
(
partition p0 values less than (2),
partition p1 values less than (10),
partition p2 values less than maxvalue
);
insert into t(j,k)values('2005-1-1 00:00:00 +02:00','16th century');
insert into t(j,k)values('2006-1-1 01:00:00 +02:00','17th century');
insert into t(j,k)values('2007-1-1 02:00:00 +02:00','18th century');
insert into t(j,k)values('2008-1-1 03:00:00 +02:00','19th century');
insert into t(j,k)values('2009-1-1 04:00:00 +02:00','20th century');
insert into t(j,k)values('2000-1-1 05:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 9:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 10:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 11:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 22:00:00 +02:00','21th century');
insert into t(j,k)values('2000-1-1 13:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;



drop table if exists t;
set timezone 'Asia/Seoul';
