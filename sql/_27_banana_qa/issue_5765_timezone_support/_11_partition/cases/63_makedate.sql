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

alter table t partition by range(makedate(dttz,277))
(
partition p0 values less than (date'2015-11-1'),
partition p1 values less than maxvalue
);
alter table t partition by range(makedate(dtltz,277))
(
partition p0 values less than (date'2015-11-1'),
partition p1 values less than maxvalue
);
alter table t partition by range(makedate(tstz,277))
(
partition p0 values less than (date'2015-11-1'),
partition p1 values less than maxvalue
);
alter table t partition by range(makedate(tsltz,277))
(
partition p0 values less than (date'2015-11-1'),
partition p1 values less than maxvalue
);
alter table t partition by range(makedate(ts,277))
(
partition p0 values less than (date'2015-11-1'),
partition p1 values less than maxvalue
);
alter table t partition by range(makedate(tt,277))
(
partition p0 values less than (date'2015-11-1'),
partition p1 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';


