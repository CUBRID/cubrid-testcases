set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(time_format(dttz,'%h:%i:%s %p %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('02:59:59 AM Asia/Shanghai  08:00'),
partition p1 values less than ('11:59:59 PM +05:00  05:00'),
partition p2 values less than ('11:59:59 PM Asia/Shanghai  08:00'),
partition p3 values less than maxvalue
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
select i from t__p__p3 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(time_format(dtltz,'%h:%i:%s %p %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('02:59:59 AM Asia/Shanghai  08:00'),
partition p1 values less than ('11:59:59 PM +05:00  05:00'),
partition p2 values less than ('11:59:59 PM Asia/Shanghai  08:00'),
partition p3 values less than maxvalue
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
select i from t__p__p3 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(time_format(tstz,'%h:%i:%s %p %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('02:59:59 AM Asia/Shanghai  08:00'),
partition p1 values less than ('11:59:59 PM +05:00  05:00'),
partition p2 values less than ('11:59:59 PM Asia/Shanghai  08:00'),
partition p3 values less than maxvalue
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
select i from t__p__p3 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(time_format(tsltz,'%h:%i:%s %p %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('02:59:59 AM Asia/Shanghai  08:00'),
partition p1 values less than ('11:59:59 PM +05:00  05:00'),
partition p2 values less than ('11:59:59 PM Asia/Shanghai  08:00'),
partition p3 values less than maxvalue
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
select i from t__p__p3 order by 1;

drop table t;
