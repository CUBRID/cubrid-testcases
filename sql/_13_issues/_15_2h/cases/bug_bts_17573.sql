set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
tt time
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',time '01:59:59');

insert into t values
(null,'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York',
datetimetz'2015-11-8 03:59:59 America/New_York',datetimetz'2015-11-8 03:59:59 America/New_York','03:59:59');

alter table t partition by range(add_months(tt,2))
(
partition p0 values less than (date'03/08/2015'),
partition p1 values less than (date'11/08/2015'),
partition p2 values less than maxvalue
);
drop table if exists t;
set timezone 'Asia/Seoul';
