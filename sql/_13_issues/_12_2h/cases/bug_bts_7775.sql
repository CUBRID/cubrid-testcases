--+ holdcas on;

create table t(i int auto_increment) partition by hash(i) partitions 3;
insert into t values(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL);
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
alter table t add partition partitions 4;
alter table t coalesce partition 3;
select distinct i from t__p__p1;
select count(*) from t;
drop t;

create table t(i int auto_increment) partition by hash(i) partitions 5;
insert into t values(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL);
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
alter table t coalesce partition 3;
alter table t add partition partitions 2;
select distinct i from t__p__p1;
select count(*) from t;
drop table t;

create table t(i int auto_increment) partition by hash(i) partitions 50;
insert into t values(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL);
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
alter table t add partition partitions 6;
alter table t coalesce partition 52;
select distinct i from t__p__p1;
select count(*) from t;
update t set i=10 where i=2;
select distinct i from t__p__p1;
select count(*) from t;
drop table t;
--+ holdcas off;





