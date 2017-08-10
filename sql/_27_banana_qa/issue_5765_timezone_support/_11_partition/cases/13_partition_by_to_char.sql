--when CUBRIDSUS-17566 has been resolved,we should change answers
set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone,
ttz datetimetz,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(dttz,'HH:MI:SS.FF AM MM/DD/YYYY'))
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
tsltz timestAMp with local time zone,
ttz datetimetz,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(dttz,'HH:MI:SS.FF AM MM/DD/YYYY TZR TZD TZH:TZM'))
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
tsltz timestAMp with local time zone,
ttz datetimetz,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(dtltz,'HH:MI:SS.FF AM MM/DD/YYYY TZR TZD TZH:TZM'))
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
tsltz timestAMp with local time zone,
ttz datetimetz,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(tstz,'HH:MI:SS AM MM/DD/YYYY TZR TZD TZH:TZM'))
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
tsltz timestAMp with local time zone,
ttz datetimetz,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(tsltz,'HH:MI:SS AM MM/DD/YYYY TZR TZD TZH:TZM'))
(
partition p0 values less than ('02:00:00 AM 03/08/2015'),
partition p1 values less than ('02:00:00 AM 11/01/2015'),
partition p2 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p2 order by 1;

set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone,
ttz datetimetz,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(ttz,'HH:MI:SS AM TZR TZD TZH:TZM'))
(
partition p0 values less than ('02:00:00 AM'),
partition p1 values less than ('02:00:00 AM 03/08/2015'),
partition p2 values less than ('02:00:00 AM 11/01/2015'),
partition p3 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p2 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p3 order by 1;
set timezone 'America/New_York';
drop table if exists t;
create table t
(
i int auto_increment,
dttz datetime with time zone,
dtltz datetime with local time zone,
tstz timestAMp with time zone,
tsltz timestAMp with local time zone,
ttz datetime with time zone,
tltz datetimeltz
);
insert into t values
(null,datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-3-8 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
insert into t values
(null,adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),
adddate(datetimetz'2015-3-8 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values
(null,adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),
adddate(datetimetz'2015-11-1 01:59:59',interval 1 second),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'),addtime(datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 00:00:01'));
insert into t values(null,datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-11-1 01:59:59',datetimetz'2015-9-17 01:59:59',datetimetz'2015-9-17 01:59:59');
alter table t partition by range(to_char(tltz,'HH:MI:SS AM TZR TZD TZH:TZM'))
(
partition p0 values less than ('02:00:00 AM'),
partition p1 values less than ('02:00:00 AM 03/08/2015'),
partition p2 values less than ('02:00:00 AM 11/01/2015'),
partition p3 values less than maxvalue
);
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p0 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p1 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p2 order by 1;
select i,dttz,dtltz,tstz,tsltz,to_char(ttz,'HH:MI:SS AM'),to_char(tltz,'HH:MI:SS AM') from t__p__p3 order by 1;
drop table if exists t;
set timezone 'Asia/Seoul';




