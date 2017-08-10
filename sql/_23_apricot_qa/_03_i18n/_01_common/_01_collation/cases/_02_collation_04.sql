drop table if exists t;
drop table if exists t__p__p1;

set names utf8;

create table t(s string collate utf8_ko_cs_uca) partition by range(s) (
partition p0 values less than ('工'),
partition p1 values less than ('年'),
partition p2 values less than ('天'));
insert into t values('工'),('年'),('年夺');
show full columns from t;
alter table t promote partition p1;
show full columns from t;
show full columns from t__p__p1;
insert into t values('工'),('年'),('年夺');
select * from t__p__p2 order by 1; 
alter table t reorganize partition p2 into (partition p1 values less than ('天'),partition p2 values less than ('年'));
drop t,t__p__p1;

create table t(s string collate utf8_ko_cs_uca) partition by range(s) (
partition p0 values less than ('假'),
partition p1 values less than ('却'),
partition p2 values less than ('刊'));

alter table t promote partition p1;
alter table t reorganize partition p2 into (partition p21 values less than ('却'),partition p22 values less than ('刊'));

drop t,t__p__p1;

create table t(s string collate utf8_ko_cs_uca) partition by range(s) (
partition p0 values less than ('가'),
partition p1 values less than ('각'),
partition p2 values less than ('간'));
insert into t values('가'),('각');
alter table t promote partition p1;
select * from t__p__p2 order by 1; 
alter table t reorganize partition p2 into (partition p21 values less than ('각'),partition p22 values less than ('간'));
drop t;
drop t__p__p1;
set names iso88591;
