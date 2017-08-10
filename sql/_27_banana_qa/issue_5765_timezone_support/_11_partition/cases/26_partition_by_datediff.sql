set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time, tltz timestamp with local time zone) partition by range(datediff(dttz,date'2010-03-02'))(
partition p0 values less than (-2),
partition p1 values less than maxvalue
);

insert into t values(null,datetimetz'2010-2-28 23:59:59',null,null,null,null,null);

insert into t values(null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,null,null);

select * from t__p__p0 order by 1;

select * from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
tltz timestamp with local time zone) partition by range(datediff(dtltz,date'2010-03-02'))(
partition p0 values less than (-2),
partition p1 values less than maxvalue
);

insert into t values(null,null,datetimetz'2010-2-28 23:59:59',null,null,null,null);

insert into t values(null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null,null);

select * from t__p__p0 order by 1;

select * from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
tltz timestamp with local time zone) partition by range(datediff(tstz,date'2010-03-02'))(
partition p0 values less than (-2),
partition p1 values less than maxvalue
);

insert into t values(null,null,null,datetimetz'2010-2-28 23:59:59',null,null,null);

insert into t values(null,null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null,null);

select * from t__p__p0 order by 1;

select * from t__p__p1 order by 1;

set timezone 'Asia/Shanghai';

drop table if exists t;

create table t(i int auto_increment,dttz datetime with time zone,dtltz datetime with local time zone,tstz timestamp with time zone,tsltz timestamp with local time zone,ttz time,
tltz timestamp with local time zone) partition by range(datediff(tsltz,date'2010-03-02'))(
partition p0 values less than (-2),
partition p1 values less than maxvalue
);

insert into t values(null,null,null,null,datetimetz'2010-2-28 23:59:59',null,null);

insert into t values(null,null,null,null,datetimeltz'2010-2-28 23:59:59 +5',null,null);

select * from t__p__p0 order by 1;

select * from t__p__p1 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';



