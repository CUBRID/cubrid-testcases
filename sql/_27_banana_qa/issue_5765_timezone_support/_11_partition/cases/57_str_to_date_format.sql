set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) ;
insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',
datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');

alter table t partition by range(str_to_date(date_format(dttz,'%Y-%m-%d %H:%i:%s %TZR %TZD'),'%Y-%m-%d %H:%i:%s %TZR %TZD '))
(
partition p0 values less than (datetimetz'2015-3-8 01:59:59 +08:00'),
partition p1 values less than (datetimetz'2015-3-8 01:59:59 +06:00'),
partition p2 values less than (datetimetz'2015-3-8 01:59:59 America/New_York'),
partition p3 values less than (datetimetz'2015-11-1 01:59:59 America/New_York EST'),
partition p4 values less than maxvalue
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
) ;
insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',
datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');

alter table t partition by range(str_to_date(date_format(dtltz,'%Y-%m-%d %H:%i:%s %TZR %TZD'),'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than (datetimeltz'2015-3-8 01:59:59 +08:00'),
partition p1 values less than (datetimeltz'2015-3-8 01:59:59 +06:00'),
partition p2 values less than (datetimeltz'2015-3-8 01:59:59 America/New_York'),
partition p3 values less than (datetimeltz'2015-11-1 01:59:59 America/New_York EST'),
partition p4 values less than maxvalue
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
) ;
insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',
datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');

alter table t partition by range(str_to_date(date_format(tstz,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM'),'%Y-%m-%d %H:%i:%s %TZR %TZD'))
(
partition p0 values less than (timestamptz'2015-3-8 01:59:59 +08:00'),
partition p1 values less than (timestamptz'2015-3-8 01:59:59 +06:00'),
partition p2 values less than (timestamptz'2015-3-8 01:59:59 America/New_York'),
partition p3 values less than (timestamptz'2015-11-1 01:59:59 America/New_York EST'),
partition p4 values less than maxvalue
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
) ;
insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',
datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');

alter table t partition by range(str_to_date(date_format(tsltz,'%Y-%m-%d %H:%i:%s %TZR %TZD'),'%Y-%m-%d %H:%i:%s %TZR %TZD'))
(
partition p0 values less than (timestampltz'2015-3-8 01:59:59 +08:00'),
partition p1 values less than (timestampltz'2015-3-8 01:59:59 +06:00'),
partition p2 values less than (timestampltz'2015-3-8 01:59:59 America/New_York'),
partition p3 values less than (timestampltz'2015-11-1 01:59:59 America/New_York EST'),
partition p4 values less than maxvalue
);
drop table if exists t;
set timezone 'Asia/Seoul';
