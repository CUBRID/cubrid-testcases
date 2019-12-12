set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(concat(date(tsltz),' 10:30:20'))
(
partition p0 values less than ('09/09/2010 10:30:20'),
partition p1 values less than maxvalue
);
insert into t values(null,datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',
datetimetz'2010-09-09 10:30:20');
insert into t values(null,datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',
datetimeltz'2010-09-09 10:30:20 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(concat(date(tstz),' 10:30:20'))
(
partition p0 values less than ('09/09/2010 10:30:20'),
partition p1 values less than maxvalue
);
insert into t values(null,datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',
datetimetz'2010-09-09 10:30:20');
insert into t values(null,datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',
datetimeltz'2010-09-09 10:30:20 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
)partition by range(concat(date(dttz),' 10:30:20'))
(
partition p0 values less than ('09/09/2010 10:30:20'),
partition p1 values less than maxvalue
);
insert into t values(null,datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',
datetimetz'2010-09-09 10:30:20');
insert into t values(null,datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',
datetimeltz'2010-09-09 10:30:20 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(concat(date(dtltz),' 10:30:20'))
(
partition p0 values less than ('09/09/2010 10:30:20'),
partition p1 values less than maxvalue
);
insert into t values(null,datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',datetimetz'2010-09-09 10:30:20',
datetimetz'2010-09-09 10:30:20');
insert into t values(null,datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',datetimeltz'2010-09-09 10:30:20 +5',
datetimeltz'2010-09-09 10:30:20 +5');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;


drop table if exists t;
set timezone 'Asia/Seoul';


