set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'nm'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'errorororor'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'mm'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'dd'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'month'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'yyyy'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'q'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');

set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'yy'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');


set timezone '+00:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(trunc(j,'day'))
(
partition p0 values less than (date'2012-01-02'),
partition p1 values less than (date'2012-12-02'),
partition p2 values less than maxvalue
);

insert into t(j)values(datetimeltz'2012-12-26 12:10:10  -3:00');
insert into t(j)values(datetimeltz'2012-1-1 23:00:00 -8:00');

set timezone '+08:00';
drop table if exists t;
create table t(i int auto_increment,j time,k datetime with time zone) partition  by range(unix_timestamp(j))
(
partition p0 values less than (1),
partition p1 values less than (36001),
partition p2 values less than maxvalue
);
insert into t(j,k)values(time'10:00:00',datetimetz'2000-1-1 23:00:00 -3:00');

drop table if exists t;
create table t(i int auto_increment,j datetime ,k varchar(20)) partition  by range(to_date(j,'YYYY-MM-DD'))
(
partition p0 values less than (date'1970-1-1'),
partition p1 values less than (date'2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetime'1969-12-31 23:59:59');
insert into t(j)values(null);
select * from t order by 1;
drop table if exists t;
create table t(i int auto_increment,j datetime ,k varchar(20)) partition  by range(to_date(j,'YYYY-MM-DD'))
(
partition p0 values less than (date'1970-1-1'),
partition p1 values less than (date'2000-1-1'),
partition p2 values less than maxvalue
);
insert into t(j)values(datetime'1969-12-31 aaaaaa');
insert into t(j)values(null);
select * from t order by 1;
drop table if exists t;
set timezone 'default';
