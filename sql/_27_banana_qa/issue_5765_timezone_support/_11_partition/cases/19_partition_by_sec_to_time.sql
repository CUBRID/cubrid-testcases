set timezone '+08:00';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);
set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 3:30:30 +8:30:30');
insert into t values (null,datetimeltz'2010-1-1 5:30:30 +8:30:30');
insert into t values (null,datetime'2010-1-1 3:00:00');
insert into t values (null,datetimeltz '2010-1-1 22:00:00  +2:50');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2:50');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45 +8:30:30');
insert into t values (null,datetimeltz'2010-1-1 06:53:45 +8:30:30');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2:50');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2:50');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone '+08:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45 +8:30:30');
insert into t values (null,datetimeltz'2010-1-1 06:53:45 +8:30:30');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2:50');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2:50');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45 +8:30:30');
insert into t values (null,datetimeltz'2010-1-1 06:53:45 +8:30:30');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2:50');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2:50');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+08:00';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone) partition by range(sec_to_time(time_to_sec(j)))
(
partition p0 values less than (time'3:00:00' ),
partition p1 values less than (time'5:00:00'),
partition p2 values less than maxvalue
);

drop table if exists t;
set timezone 'Asia/Seoul';


