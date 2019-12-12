set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(month(dttz))
(
partition p0 values less than (3),
partition p1 values less than (4),
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
) partition by range(month(dtltz))
(
partition p0 values less than (3),
partition p1 values less than (4),
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
) partition by range(month(tstz))
(
partition p0 values less than (3),
partition p1 values less than (4),
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
) partition by range(month(tsltz))
(
partition p0 values less than (3),
partition p1 values less than (4),
partition p2 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');
insert into t values (null,datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul',datetimetz'2010-2-28 23:59:59 Asia/Seoul');

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone ,k varchar(20)) partition  by range(month(j))
(
partition p0 values less than (4),
partition p1 values less than (6),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2008-12-31 23:59:59 -3:00');
insert into t(j)values(subdate(datetimeltz'2008-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-5-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;



set timezone '+3:45';
drop table if exists t;
create table t(i int auto_increment,j datetime with local time zone ,k varchar(20)) partition  by range(month(j))
(
partition p0 values less than (4),
partition p1 values less than (6),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2008-12-31 23:59:59 -3:00');
insert into t(j)values(subdate(datetimeltz'2008-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-5-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

drop table if exists t;
create table t(i int auto_increment,j timestamp with time zone ,k varchar(20)) partition  by range(month(j))
(
partition p0 values less than (4),
partition p1 values less than (6),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2008-12-31 23:59:59 -3:00');
insert into t(j)values(subdate(datetimeltz'2008-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-5-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;



set timezone '+3:45';
drop table if exists t;
create table t(i int auto_increment,j timestamp with local time zone ,k varchar(20)) partition  by range(month(j))
(
partition p0 values less than (4),
partition p1 values less than (6),
partition p2 values less than maxvalue
);
insert into t(j)values(datetimeltz'2008-12-31 23:59:59 -3:00');
insert into t(j)values(subdate(datetimeltz'2008-12-31 23:59:59',interval 1 hour ));
insert into t(j)values(adddate(datetimeltz'1999-5-31 23:59:59',interval 1 second));
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

 drop table if exists t;
set timezone 'Asia/Seoul';
