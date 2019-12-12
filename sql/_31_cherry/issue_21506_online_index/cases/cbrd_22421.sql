drop table if exists t1;

create table t1(a int,b int);

insert into t1 values(1,1),(2,2),(3,3);

create index idx1 on t1(a) with online;

create index idx2 on t1(b);

create unique index idx3 on t1(a,b) with online;

select index_name,status from db_index where class_name = 't1' order by 1;

alter index idx1 on t1 invisible;

select index_name,status from db_index where class_name = 't1' order by 1;

drop t1;
