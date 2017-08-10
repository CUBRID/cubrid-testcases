drop table if exists t__p__p1;
drop table if exists t;
set names utf8;

create table t(s string collate utf8_ko_cs_uca) partition by range(s) (
partition p0 values less than ('假'),
partition p1 values less than ('却'),
partition p2 values less than ('刊'));

insert into t values('伽'),('假'),('却');

alter table t promote partition p1;
alter table t reorganize partition p2 into (partition p21 values less than ('却'),partition p22 values less than ('刊'));
insert into t values('伽'),('假'),('却');
select * from t__p__p0;
select * from t__p__p1;
select * from t__p__p21;
select * from t__p__p22;
insert into t values('刊');
insert into t__p__p1 values('伽'),('假'),('却');

drop t__p__p1;
drop t;
set names iso88591;
