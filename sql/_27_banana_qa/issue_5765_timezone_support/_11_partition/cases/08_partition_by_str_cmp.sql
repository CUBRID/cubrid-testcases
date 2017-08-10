set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz timestamp,tltz time) partition by range(strcmp(dttz,datetimetz'2010-2-28 23:59:59'))(
partition p0 values less than (0),
partition p1 values less than (1),
partition p2 values less than (2)
);

insert into t values(null,datetimetz'2010-2-28 23:59:59',null,null,null,null,null);

insert into t values(null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,null,null);

select * from t__p__p0;

select * from t__p__p1;

set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz timestamp,tltz time) partition by range(strcmp(dtltz,datetimetz'2010-2-28 23:59:59'))(
partition p0 values less than (0),
partition p1 values less than (1),
partition p2 values less than (2)
);

insert into t values(null,null,datetimetz'2010-2-28 23:59:59',null,null,null,null);

insert into t values(null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,null);

select * from t__p__p0;

select * from t__p__p1;

set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz timestamp,tltz time) partition by range(strcmp(tstz,timestamptz'2010-2-28 23:59:59'))(
partition p0 values less than (0),
partition p1 values less than (1),
partition p2 values less than (2)
);

insert into t values(null,null,null,datetimetz'2010-2-28 23:59:59',null,null,null);

insert into t values(null,null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null);

select * from t__p__p0;

select * from t__p__p1;

set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz timestamp,tltz time) partition by range(strcmp(tsltz,timestamptz'2010-2-28 23:59:59'))(
partition p0 values less than (0),
partition p1 values less than (1),
partition p2 values less than (2)
);

insert into t values(null,null,null,null,datetimetz'2010-2-28 23:59:59',null,null);

insert into t values(null,null,null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null);

select * from t__p__p0;

select * from t__p__p1;


drop table if exists t;
set timezone 'Asia/Seoul';



