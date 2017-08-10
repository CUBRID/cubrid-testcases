set timezone 'America/New_York';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(subdate(dttz,interval 1 hour))
(
partition p0 values less than (datetimetz'2010-2-28 23:59:59'),
partition p1 values less than (datetimetz'2015-3-8 3:00:00 am'),
partition p2 values less than (datetimetz'2015-11-1 1:59:59 am'),
partition p3 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

insert into t values
(null,datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am'
);

insert into t values
(null,datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am');
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST',
datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT',
datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT'
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(subdate(dtltz,interval 1 hour))
(
partition p0 values less than (datetimetz'2010-2-28 23:59:59'),
partition p1 values less than (datetimetz'2015-3-8 3:00:00 am'),
partition p2 values less than (datetimetz'2015-11-1 1:59:59 am'),
partition p3 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

insert into t values
(null,datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am'
);

insert into t values
(null,datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST',
datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT',
datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT'
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(subdate(tstz,interval 1 hour))
(
partition p0 values less than (datetimetz'2010-2-28 23:59:59'),
partition p1 values less than (datetimetz'2015-3-8 3:00:00 am'),
partition p2 values less than (datetimetz'2015-11-1 1:59:59 am'),
partition p3 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

insert into t values
(null,datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am'
);

insert into t values
(null,datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST',
datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT',
datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT'
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestamp with time zone,
tsltz timestamp with local time zone
) partition by range(subdate(tsltz,interval 1 hour))
(
partition p0 values less than (datetimetz'2010-2-28 23:59:59'),
partition p1 values less than (datetimetz'2015-3-8 3:00:00 am'),
partition p2 values less than (datetimetz'2015-11-1 1:59:59 am'),
partition p3 values less than maxvalue
);
insert into t values
(null,datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59',datetimetz'2010-2-28 23:59:59');
insert into t values
(null,datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5',datetimeltz'2010-2-28 23:59:59 +5');
insert into t values
(null,datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5',datetimetz'2010-2-28 23:59:59 +5');

insert into t values
(null,datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am',datetimetz'2015-3-8 3:00:00 am'
);

insert into t values
(null,datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am',datetimetz'2015-11-1 2:00:00 am'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST',
datetimetz'2015-11-1 1:59:59 am America/New_York EST',datetimetz'2015-11-1 1:59:59 am America/New_York EST'
);
insert into t values
(null,datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT',
datetimetz'2015-11-1 1:59:59 am America/New_York EDT',datetimetz'2015-11-1 1:59:59 am America/New_York EDT'
);

select i from t__p__p0 order by 1;
select i from t__p__p1 order by 1;
select i from t__p__p2 order by 1;
select i from t__p__p3 order by 1;

drop table if exists t;
set timezone 'Asia/Seoul';


