set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone) partition by range(timediff(j,datetimetz'2010-01-01 03:04:05'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1; 
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';



set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone) partition by range(timediff(j,datetimetz'2010-01-01 03:04:05'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1; 
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone) partition by range(timediff(j,datetimeltz'2010-01-01 04:04:05 Asia/Seoul'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone) partition by range(timediff(j,datetimetz'2010-01-01 03:04:05 Asia/Seoul'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone) partition by range(timediff(j,datetimetz'2010-01-01 03:04:05'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1; 
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';



set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone) partition by range(timediff(j,datetimetz'2010-01-01 03:04:05'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1; 
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone) partition by range(timediff(j,datetimeltz'2010-01-01 04:04:05 Asia/Seoul'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone) partition by range(timediff(j,datetimetz'2010-01-01 03:04:05 Asia/Seoul'))
(
partition p0 values less than (time'04:00:00'),
partition p1 values less than (time'12:00:00'),
partition p2 values less than maxvalue
);
insert into t values (null,datetimetz'2010-1-1 06:53:45');
insert into t values (null,datetimeltz'2010-1-1 06:53:45');
insert into t values (null,datetime'2010-1-1 06:53:45');
insert into t values (null,datetimeltz '2010-1-1 06:53:45 +2');
insert into t values (null,datetimetz '2010-1-1 06:53:45 +2');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(timediff(dttz,datetimetz'2010-2-28 22:59:59'))
(
partition p0 values less than (time'1:00:00'),
partition p1 values less than (time'2:00:00'),
partition p2 values less than maxvalue
);

insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(timediff(dtltz,datetimetz'2010-2-28 22:59:59'))
(
partition p0 values less than (time'1:00:00'),
partition p1 values less than (time'2:00:00'),
partition p2 values less than maxvalue
);

insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(timediff(tstz,datetimetz'2010-2-28 22:59:59'))
(
partition p0 values less than (time'1:00:00'),
partition p1 values less than (time'2:00:00'),
partition p2 values less than maxvalue
);

insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(timediff(tsltz,datetimetz'2010-2-28 22:59:59'))
(
partition p0 values less than (time'1:00:00'),
partition p1 values less than (time'2:00:00'),
partition p2 values less than maxvalue
);

insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;




drop table if exists t;
set timezone 'Asia/Seoul';
