drop table if exists t1, t2;
create table t1 ( a int, b int );
create table t2 UNDER t1 (a int);
--csql crashed for below:
create index i1 on t1(a) with online;

show index from t1;
show index from t2;

drop table t1, t2;
