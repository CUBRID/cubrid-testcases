set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j string,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);
insert into t values
(null,'2010-2-28 23:59:59','2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
alter table t
partition by range(field(dttz,'11:59:59.000 PM 02/28/2010 Asia/Shanghai','11:59:59.000 PM 02/28/2010 Asia/Shanghai'))
(
partition p0 values less than (1),
partition p1 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j string,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);
insert into t values
(null,'2010-2-28 23:59:59','2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
alter table t
partition by range(field(dtltz,'11:59:59.000 PM 02/28/2010 Asia/Shanghai','11:59:59.000 PM 02/28/2010 Asia/Shanghai'))
(
partition p0 values less than (1),
partition p1 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j string,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);
insert into t values
(null,'2010-2-28 23:59:59','2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
alter table t
partition by range(field(tstz,'11:59:59.000 PM 02/28/2010 Asia/Shanghai','11:59:59.000 PM 02/28/2010 Asia/Shanghai'))
(
partition p0 values less than (1),
partition p1 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j string,
ts timestamp,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);
insert into t values
(null,'2010-2-28 23:59:59','2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
alter table t
partition by range(field(tsltz,'11:59:59.000 PM 02/28/2010 Asia/Shanghai','11:59:59.000 PM 02/28/2010 Asia/Shanghai'))
(
partition p0 values less than (1),
partition p1 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;

