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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(date_format(dttz,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('2015-03-08 01:59:59 Asia/Shanghai  +08:00'),
partition p1 values less than ('2015-03-08 03:00:00 America/New_York EDT -04:00'),
partition p2 values less than ('2015-11-01 01:00:00 America/New_York EST -05:00'),
partition p3 values less than ('2015-11-01 01:59:59 America/New_York EST -05:00'),
partition p4 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;
select i from t__p__p4 order by 1;

set timezone 'America/New_York';
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
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(date_format(dtltz,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('2015-03-08 01:59:59 Asia/Shanghai  +08:00'),
partition p1 values less than ('2015-03-08 03:00:00 America/New_York EDT -04:00'),
partition p2 values less than ('2015-11-01 01:00:00 America/New_York EST -05:00'),
partition p3 values less than ('2015-11-01 01:59:59 America/New_York EST -05:00'),
partition p4 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;
select i from t__p__p4 order by 1;

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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values 
(null,'2015-3-8 01:59:59 America/New_York',
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second)
);
insert into t values
(null,
'2015-11-1 01:59:59 America/New_York',
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(date_format(tstz,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('2015-03-08 01:59:59 Asia/Shanghai  +08:00'),
partition p1 values less than ('2015-03-08 03:00:00 America/New_York EDT -04:00'),
partition p2 values less than ('2015-11-01 01:00:00 America/New_York EST -05:00'),
partition p3 values less than ('2015-11-01 01:59:59 America/New_York EST -05:00'),
partition p4 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;
select i from t__p__p4 order by 1;

set timezone 'America/New_York';
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
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59'
);
insert into t values
(null,'2015-3-8 01:59:59 America/New_York',adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,
'2015-11-1 01:59:59 America/New_York',
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(date_format(tsltz,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM'))
(
partition p0 values less than ('2015-03-08 01:59:59 Asia/Shanghai  +08:00'),
partition p1 values less than ('2015-03-08 03:00:00 America/New_York EDT -04:00'),
partition p2 values less than ('2015-11-01 01:00:00 America/New_York EST -05:00'),
partition p3 values less than ('2015-11-01 01:59:59 America/New_York EST -05:00'),
partition p4 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;
select i from t__p__p4 order by 1;

drop table if exists t;
set timezone 'Asia/Seoul';

