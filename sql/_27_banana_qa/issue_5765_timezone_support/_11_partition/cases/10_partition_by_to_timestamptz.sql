set timezone '+08:00';
drop table if exists t;
create table t
(
i int auto_increment,
dt datetime,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);


insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-
28 23:59:59 +5');
insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28   23:59:59 +5');

alter table t partition by range(to_timestamp_tz(dt))
(
partition p0 values less than (timestamptz '2010-2-28 23:59:59'),
partition p2 values less than maxvalue
);

alter table t partition by range(to_timestamp_tz(ts))
(
partition p0 values less than (timestamptz '2010-2-28 23:59:59'),
partition p2 values less than maxvalue
);

set timezone '+08:00';
drop table if exists t;
create table t
(
i int auto_increment,
dt datetime,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
); 


insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-
28 23:59:59 +5');
insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28  
 23:59:59 +5');
 
alter table t partition by range(to_timestamp_tz(dttz))
(
partition p0 values less than (timestamptz '2010-2-28 23:59:59'),
partition p2 values less than maxvalue
);

alter table t partition by range(to_timestamp_tz(tstz))
(
partition p0 values less than (timestamptz '2010-2-28 23:59:59'),
partition p2 values less than maxvalue
);

set timezone '+08:00';
drop table if exists t;
create table t
(
i int auto_increment,
dt datetime,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
); 


insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-
28 23:59:59 +5');
insert into t values
(null,datetime'2010-2-28 23:59:59',timestamp'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28  
 23:59:59 +5');

alter table t partition by range(to_timestamp_tz(dtltz))
(
partition p0 values less than (timestamptz '2010-2-28 23:59:59'),
partition p2 values less than maxvalue
);

alter table t partition by range(to_timestamp_tz(tsltz))
(
partition p0 values less than (timestamptz '2010-2-28 23:59:59'),
partition p2 values less than maxvalue
);



drop table if exists t;
set timezone 'Asia/Seoul';
