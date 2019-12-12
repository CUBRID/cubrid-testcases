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
(null,
'2015-3-8 01:59:59 America/New_York',
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(to_datetime_tz(concat(timestamp(dttz),' +08:00')))
(
partition p0 values less than (datetimetz'2015-3-8 01:00:00 AM +08:00 '),
partition p1 values less than (datetimetz'2015-3-8 01:59:59 AM +08:00 '),
partition p2 values less than (datetimetz'2015-3-8 03:00:00 AM +08:00'),
partition p3 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

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
(null,
'2015-3-8 01:59:59 America/New_York',
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(to_datetime_tz(concat(timestamp(dtltz),' +08:00')))
(
partition p0 values less than (datetimetz'2015-3-8 01:00:00 AM +08:00 '),
partition p1 values less than (datetimetz'2015-3-8 01:59:59 AM +08:00 '),
partition p2 values less than (datetimetz'2015-3-8 03:00:00 AM +08:00'),
partition p3 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

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
(null,
'2015-3-8 01:59:59 America/New_York',
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(to_datetime_tz(concat(timestamp(tstz),' +08:00')))
(
partition p0 values less than (datetimetz'2015-3-8 01:00:00 AM +08:00 '),
partition p1 values less than (datetimetz'2015-3-8 01:59:59 AM +08:00 '),
partition p2 values less than (datetimetz'2015-3-8 03:00:00 AM +08:00'),
partition p3 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

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
(null,
'2015-3-8 01:59:59 America/New_York',
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59 America/New_York',interval 1 second));
insert into t values
(null,'2015-11-1 01:59:59 America/New_York',
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59 America/New_York',interval 1 second));
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST',
datetimetz'2015-11-1 01:59:59 America/New_York EST',datetimetz'2015-11-1 01:59:59 America/New_York EST');


alter table t partition by range(to_datetime_tz(concat(timestamp(tsltz),' +08:00')))
(
partition p0 values less than (datetimetz'2015-3-8 01:00:00 AM +08:00 '),
partition p1 values less than (datetimetz'2015-3-8 01:59:59 AM +08:00 '),
partition p2 values less than (datetimetz'2015-3-8 03:00:00 AM +08:00'),
partition p3 values less than maxvalue
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

drop table if exists t;
set timezone 'Asia/Seoul';
