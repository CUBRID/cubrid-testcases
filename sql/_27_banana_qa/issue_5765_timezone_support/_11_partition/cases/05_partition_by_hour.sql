set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(hour(dttz))
(
partition p0 values less than (3),
partition p1 values less than (23),
partition p2 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul');
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
) partition by range(hour(dtltz))
(
partition p0 values less than (3),
partition p1 values less than (23),
partition p2 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul');

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
) partition by range(hour(tstz))
(
partition p0 values less than (3),
partition p1 values less than (23),
partition p2 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul');

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
) partition by range(hour(tsltz))
(
partition p0 values less than (3),
partition p1 values less than (23),
partition p2 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul',datetimeltz'2010-2-28 23:59:59 Asia/Seoul');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


drop table if exists t;
set timezone 'Asia/Seoul';
