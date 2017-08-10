set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as varchar))
(
partition p0 values less than ('02:00:00 AM 03/08/2015'),
partition p1 values less than ('02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as char(100)))
(
partition p0 values less than ('02:00:00 AM 03/08/2015'),
partition p1 values less than ('02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as char(100)))
(
partition p0 values less than ('02:00:00 AM 03/08/2015'),
partition p1 values less than ('02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as varchar))
(
partition p0 values less than ('02:00:00 AM 03/08/2015'),
partition p1 values less than ('02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as date))
(
partition p0 values less than (date'03/08/2015'),
partition p1 values less than (date'11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as date))
(
partition p0 values less than (date'03/08/2015'),
partition p1 values less than (date'11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as date))
(
partition p0 values less than (date'03/08/2015'),
partition p1 values less than (date'11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as date))
(
partition p0 values less than (date'03/08/2015'),
partition p1 values less than (date'11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as timestamp))
(
partition p0 values less than (timestamp'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamp'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as timestamp))
(
partition p0 values less than (timestamp'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamp'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as timestamp))
(
partition p0 values less than (timestamp'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamp'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as timestamp))
(
partition p0 values less than (timestamp'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamp'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;



set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as timestamptz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as timestamptz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as timestamptz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as timestamptz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as timestampltz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as timestampltz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;


set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as timestampltz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as timestampltz))
(
partition p0 values less than (timestamptz'03:00:00 AM 03/08/2015'),
partition p1 values less than (timestamptz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;



set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as datetime))
(
partition p0 values less than (datetime'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetime'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as datetime))
(
partition p0 values less than (datetime'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetime'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as datetime))
(
partition p0 values less than (datetime'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetime'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as datetime))
(
partition p0 values less than (datetime'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetime'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as datetimetz))
(
partition p0 values less than (datetimetz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimetz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as datetimetz))
(
partition p0 values less than (datetimetz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimetz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as datetimetz))
(
partition p0 values less than (datetimetz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimetz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as datetimetz))
(
partition p0 values less than (datetimetz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimetz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);



set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as datetimeltz))
(
partition p0 values less than (datetimeltz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimeltz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as datetimeltz))
(
partition p0 values less than (datetimeltz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimeltz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as datetimeltz))
(
partition p0 values less than (datetimeltz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimeltz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as datetimeltz))
(
partition p0 values less than (datetimeltz'03:00:00 AM 03/08/2015'),
partition p1 values less than (datetimeltz'02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);



set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dttz as time))
(
partition p0 values less than (time'02:00:00 AM'),
partition p1 values less than (time'03:00:00 AM'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(dtltz as time))
(
partition p0 values less than (time'02:00:00 AM'),
partition p1 values less than (time'03:00:00 AM'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tstz as time))
(
partition p0 values less than (time'02:00:00 AM'),
partition p1 values less than (time'03:00:00 AM'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59');
alter table t partition by range(cast(tsltz as time))
(
partition p0 values less than (time'02:00:00 AM'),
partition p1 values less than (time'03:00:00 AM'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz from t__p__p2 order by 1;

drop table if exists t;
set timezone 'Asia/Seoul';

