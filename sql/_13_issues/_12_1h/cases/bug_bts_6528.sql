drop if exists t1;
create table t1(i int);
insert into t1 values(0);
do (select * from t1);

insert into t1 select rownum from db_class limit 40;
insert into t1 select * from t1;
do(select count(*) from t1);

drop t1;
create table t1(i varchar(10) primary key);
insert into t1 values('50');
do (select * from t1);
insert into t1 select cast(rownum as varchar) from db_class limit 40;
do(select count(*) from t1);

drop t1;
create table t1(i int primary key,j int) partition by hash(i) partitions 3;
insert into t1 values(50,50);
do (select j from t1);
insert into t1 select rownum,rownum from db_class limit 40;
do(select count(*) from t1);

drop t1;