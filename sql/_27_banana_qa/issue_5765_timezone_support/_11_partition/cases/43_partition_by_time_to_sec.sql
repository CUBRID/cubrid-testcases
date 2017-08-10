set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (43200),
partition p1 values less than (82800),
partition p2 values less than maxvalue
);
insert into t(j,k)values(' 2015-8-27 00:00:00','16th century');
insert into t(j,k)values(' 2015-8-27 00:00:00 pm','16th century');
insert into t(j,k)values(' 2015-8-27 11:00:00','17th century');
insert into t(j,k)values(' 2015-8-27 11:00:00 pm','17th century');
insert into t(j,k)values(datetimeltz'2015-8-27 11:00:00 pm -1:00','17th century');
insert into t(j,k)values(' 2015-8-27 23:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
set timezone 'Asia/Seoul';
insert into t(j,k)values(' 2015-8-27 00:00:00 +01:00','16th century');
set timezone 'America/New_York';
insert into t(j,k)values(' 2015-8-27 23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
set timezone 'Asia/Seoul';
insert into t(j,k)values('2015-8-27  00:00:00 +01:00','16th century');
set timezone 'America/New_York';
insert into t(j,k)values(' 2015-8-27 23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
insert into t(j,k)values('2015-8-27  00:00:00 +01:00','16th century');
insert into t(j,k)values('2015-8-27  23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
insert into t(j,k)values('2015-8-27 00:00:00 +01:00','16th century');
insert into t(j,k)values('2015-8-27  23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (43200),
partition p1 values less than (82800),
partition p2 values less than maxvalue
);
insert into t(j,k)values(' 2015-8-27 00:00:00','16th century');
insert into t(j,k)values(' 2015-8-27 00:00:00 pm','16th century');
insert into t(j,k)values(' 2015-8-27 11:00:00','17th century');
insert into t(j,k)values(' 2015-8-27 11:00:00 pm','17th century');
insert into t(j,k)values(datetimeltz'2015-8-27 11:00:00 pm -1:00','17th century');
insert into t(j,k)values(' 2015-8-27 23:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
set timezone 'Asia/Seoul';
insert into t(j,k)values(' 2015-8-27 00:00:00 +01:00','16th century');
set timezone 'America/New_York';
insert into t(j,k)values(' 2015-8-27 23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
set timezone 'Asia/Seoul';
insert into t(j,k)values('2015-8-27  00:00:00 +01:00','16th century');
set timezone 'America/New_York';
insert into t(j,k)values(' 2015-8-27 23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
insert into t(j,k)values('2015-8-27  00:00:00 +01:00','16th century');
insert into t(j,k)values('2015-8-27  23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j datetime with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
insert into t(j,k)values('2015-8-27 00:00:00 +01:00','16th century');
insert into t(j,k)values('2015-8-27  23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (43200),
partition p1 values less than (82800),
partition p2 values less than maxvalue
);
insert into t(j,k)values(' 2015-8-27 00:00:00','16th century');
insert into t(j,k)values(' 2015-8-27 00:00:00 pm','16th century');
insert into t(j,k)values(' 2015-8-27 11:00:00','17th century');
insert into t(j,k)values(' 2015-8-27 11:00:00 pm','17th century');
insert into t(j,k)values(datetimeltz'2015-8-27 11:00:00 pm -1:00','17th century');
insert into t(j,k)values(' 2015-8-27 23:00:00','21th century');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
set timezone 'Asia/Seoul';
insert into t(j,k)values(' 2015-8-27 00:00:00 +01:00','16th century');
set timezone 'America/New_York';
insert into t(j,k)values(' 2015-8-27 23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
set timezone 'Asia/Seoul';
insert into t(j,k)values('2015-8-27  00:00:00 +01:00','16th century');
set timezone 'America/New_York';
insert into t(j,k)values(' 2015-8-27 23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
insert into t(j,k)values('2015-8-27  00:00:00 +01:00','16th century');
insert into t(j,k)values('2015-8-27  23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone,k varchar(20)) partition  by range(time_to_sec(j))
(
partition p0 values less than (82800),
partition p1 values less than maxvalue
);
insert into t(j,k)values('2015-8-27 00:00:00 +01:00','16th century');
insert into t(j,k)values('2015-8-27  23:00:00 +02:00','21th century');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';
