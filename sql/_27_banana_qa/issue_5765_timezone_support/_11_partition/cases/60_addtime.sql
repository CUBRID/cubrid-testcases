set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dttz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dtltz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');

insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tstz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tsltz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;





set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dttz,datetimetz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dtltz,datetimetz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tstz,datetimetz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;



set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');

insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tsltz,datetimetz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;




set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dttz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dtltz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tstz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tsltz,time'00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;





set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dttz,timestamptz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(dtltz,timestamptz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tstz,timestamptz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;



set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
j varchar,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
);

insert into t values
(null,'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York',
datetimetz'2015-3-8 03:59:59 America/New_York',datetimetz'2015-3-8 03:59:59 America/New_York');

alter table t partition by range(addtime(tsltz,timestamptz'2000-1-1 00:00:01'))
(
partition p0 values less than (datetimetz'02:00:00.000 AM 03/08/2015 Asia/Shanghai'),
partition p1 values less than (datetimetz'04:00:00.000 AM 03/08/2015 America/New_York EDT'),
partition p2 values less than maxvalue
);
select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;

drop table if exists t;
set timezone 'Asia/Seoul';


