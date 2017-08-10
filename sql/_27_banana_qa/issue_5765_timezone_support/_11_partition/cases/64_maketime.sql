--wait CUBRIDSUS-17573 to be resolved
set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ts timestamp,
tt time
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',
timestamp'2015-3-8 01:59:59',time'01:59:59');
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',
datetimetz'2015-11-1 01:59:59 America/New_York',datetimetz'2015-11-1 01:59:59 America/New_York',timestamp'2015-3-8 01:59:59',time'01:59:59');

alter table t partition by range(maketime(dttz,30,30))
(
partition p0 values less than (time'23:59:59'),
partition p1 values less than maxvalue
);
alter table t partition by range(maketime(dtltz,30,30))
(
partition p0 values less than (time'23:59:59'),
partition p1 values less than maxvalue
);
alter table t partition by range(maketime(tstz,30,30))
(
partition p0 values less than (time'23:59:59'),
partition p1 values less than maxvalue
);
alter table t partition by range(maketime(tsltz,30,30))
(
partition p0 values less than (time'23:59:59'),
partition p1 values less than maxvalue
);
alter table t partition by range(maketime(ts,30,30))
(
partition p0 values less than (time'23:59:59'),
partition p1 values less than maxvalue
);
alter table t partition by range(maketime(tt,30,30))
(
partition p0 values less than (time'23:59:59'),
partition p1 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
drop table if exist t;
set timezone 'Asia/Seoul';
