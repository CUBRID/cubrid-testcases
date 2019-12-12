--wait CUBRIDSUS-17580/CUBRIDSUS-17565/CUBRIDSUS-17567 to be resolved
set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(1,dttz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,datetimetz'2010-2-28 23:59:59',null,null,null,null,null);
insert into t values(null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,null,null);
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
tsltz timestamp with local time zone,
ttz timestamp,
tltz time) 
partition by range(elt(1,dtltz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,null,datetimetz'2010-2-28 23:59:59',null,null,null,null);
insert into t values(null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time) 
partition by range(elt(1,tstz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,null,null,datetimetz'2010-2-28 23:59:59',null,null,null);
insert into t values(null,null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3;

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time) 
partition by range(elt(1,tsltz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,null,null,null,datetimetz'2010-2-28 23:59:59',null,null);
insert into t values(null,null,null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null);
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3;
set timezone 'Asia/Seoul';


set timezone 'Asia/Shanghai';
drop table if exists t;

create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time ) partition by range(elt(1,ttz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,null,null,null,null,datetimetz'2015-9-17 23:59:59',null);
insert into t values(null,null,null,null,null,datetimeltz'2015-9-17 23:59:59 +5',null);
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
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) 
partition by range(elt(1,tltz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

insert into t values(null,null,null,null,null,null,time'23:59:59');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
select * from t__p__p3;
set timezone 'Asia/Seoul';

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(1,dttz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',time'23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',time'23:59:59');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+08:00';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(1,dttz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
insert into t values(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',time'23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',time'23:59:59');
select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;


set timezone '+08:00';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
);
insert into t values(null,datetimetz'2010-2-28 23:59:59',null,null,null,timestamp'2010-2-28 23:59:59',time'23:59:59');
insert into t values(null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,timestamp'2010-2-28 23:59:59',time'23:59:59');
alter table t partition by range(elt(1,ttz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

select * from t__p__p0 order by 1;
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;

set timezone '+08:00';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
)partition by range(elt(1,ttz))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

insert into t values(null,datetimetz'2010-2-28 23:59:59',null,null,null,timestamp'2010-2-28 23:59:59',time'23:59:59');
insert into t values(null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,timestamp'2010-2-28 23:59:59',time'23:59:59');

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
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(1,dttz,'2010-2-28 23:59:59 +5','2010-2-28 23:59:59','2010-2-28 23:59:59 +5','23:59:59','23:59:59 +5'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

drop table if exists t;

create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(2,dttz,'2010-2-28 23:59:59 +5','2010-2-28 23:59:59','2010-2-28 23:59:59 +5','23:59:59','23:59:59 +5'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

drop table if exists t;

create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(3,dttz,'2010-2-28 23:59:59 +5','2010-2-28 23:59:59','2010-2-28 23:59:59 +5','23:59:59','23:59:59 +5'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

drop table if exists t;

create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(4,dttz,'2010-2-28 23:59:59 +5','2010-2-28 23:59:59','2010-2-28 23:59:59 +5','23:59:59','23:59:59 +5'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);


drop table if exists t;

create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(5,dttz,'2010-2-28 23:59:59 +5','2010-2-28 23:59:59','2010-2-28 23:59:59 +5','23:59:59','23:59:59 +5'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);

drop table if exists t;

create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone,
ttz timestamp,
tltz time
) partition by range(elt(6,dttz,'2010-2-28 23:59:59 +5','2010-2-28 23:59:59','2010-2-28 23:59:59 +5','23:59:59','23:59:59 +5'))
(
partition p0 values less than ('1'),
partition p1 values less than ('2'),
partition p2 values less than ('3'),
partition p3 values less than maxvalue
);
drop table if exists t;
set timezone 'Asia/Seoul';
