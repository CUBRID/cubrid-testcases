drop table if exists t1;
create table t1 (a int, b int);
insert into t1 values (1,1),(2,2),(3,3);
create index t1_idx_a on t1(a);
create index t1_idx_ab on t1(a,b);

drop table if exists t2;
create table t2 (a int, b int);
insert into t2 values (1,1),(2,2),(3,3);
create index t2_idx_a on t2(a);
create index t2_idx_ab on t2(a,b);


select /*+ recompile */ sum(a),sum(b) from t1 ;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 ,t2 where t1.a=t2.a;

drop table t1,t2;

create table t1 (a int, b int) partition by hash(a) partitions 5;
insert into t1 values (1,1),(2,2),(3,3);
create index t1_idx_a on t1(a);
create index t1_idx_ab on t1(a,b);

drop table if exists t2;
create table t2 (a int, b int) partition by hash(b) partitions 5;
insert into t2 values (1,1),(2,2),(3,3);
create index t2_idx_a on t2(a);
create index t2_idx_ab on t2(a,b);


select /*+ recompile */ sum(a),sum(b) from t1 ;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 ,t2 where t1.a=t2.a;

drop table t1,t2;




