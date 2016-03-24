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


select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,0;

select /*+ recompile */ sum(a),sum(b) from t1 ;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_a keylimit 0,2;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_ab keylimit 0,2;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_ab keylimit 0,3;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_ab keylimit 0,0;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 ,t2 where t1.a=t2.a;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 left join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,2;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,2;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,1;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,0;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a(-)  keylimit 0,0;

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


select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,0;

select /*+ recompile */ sum(a),sum(b) from t1 ;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_a keylimit 0,2;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_ab keylimit 0,2;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_ab keylimit 0,3;

select /*+ recompile */ sum(a),sum(b) from t1 where a>0 using index t1_idx_ab keylimit 0,0;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 ,t2 where t1.a=t2.a;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 left join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,2;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,2;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,1;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a keylimit 0,0;

select /*+ recompile */ sum(t1.a),sum(t2.b) from t1 right join t2 on t1.b=t2.b where t1.a>0 using index t1_idx_a(-)  keylimit 0,0;

drop table t1,t2;




