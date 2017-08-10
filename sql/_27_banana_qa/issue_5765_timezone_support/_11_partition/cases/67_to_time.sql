set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');

insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York');

alter table t partition by range(to_time_tz(tsltz))
(
partition p0 values less than (time'01:59:59 -4'),
partition p1 values less than (time'02:59:59 -5'),
partition p2 values less than maxvalue
);


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimeltz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');


alter table t partition by range(to_time(dttz))
(
partition p0 values less than (time'01:59:59'),
partition p1 values less than (time'03:59:59'),
partition p2 values less than maxvalue
);

alter table t partition by range(to_time(dtltz))
(
partition p0 values less than (time'01:59:59'),
partition p1 values less than (time'03:59:59'),
partition p2 values less than maxvalue
);
alter table t partition by range(to_time(tstz))
(
partition p0 values less than (time'01:59:59'),
partition p1 values less than (time'03:59:59'),
partition p2 values less than maxvalue
);
alter table t partition by range(to_time(tsltz))
(
partition p0 values less than (time'01:59:59'),
partition p1 values less than (time'03:59:59'),
partition p2 values less than maxvalue
);

drop table if exists t;
set timezone 'Asia/Seoul';



