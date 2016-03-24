set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t1,t2;

create table t1 (a int primary key) partition by hash(a) partitions 3; 
insert into t1 select rownum from db_class limit 44;

create table t2 (a int primary key) partition by hash(a) partitions 3; 
insert into t2 select rownum from db_class limit 48;

update statistics on t1, t2;

select /*+ recompile */ t1.a, t2.a from t1, t2 where t1.a = t2.a order by 1, 2;

select /*+ recompile */ t1.a, t2.a from t1 left join t2 on t1.a = t2.a order by 1, 2;

select /*+ recompile */ t1.a, t2.a from t1, t2 where t1.a = t2.a and t1.a = 25;

select /*+ recompile */ t1.a, t2.a from t1 left join t2 on t1.a = t2.a where t1.a = 25;

select /*+ recompile */ t1.a, t2.a from t1 right join t2 on t1.a = t2.a where t1.a = 25;

drop table t1;

drop table t2;

create table t1 (i int);
create table t2(i int, j int) partition by range(i) (partition p0 values less than (10), partition p2 values less than (21));

insert into t1 select rownum from _db_class limit 20;
insert into t2 select rownum, rownum from _db_class limit 20;

create index i_t2_j on t2(j);

update statistics on t1, t2;

select /*+ recompile ordered */ * from t1, t2 where t1.i = t2.j;

drop table t1;
drop table t2;

create table t1(i int auto_increment,j int, primary key(i,j));
insert into t1 values(1,2),(NULL,3);

create table t2(i int,j int,k int) partition by hash(i) partitions 4;
alter table t2 add constraint foreign key t2(i,j) references t1(i,j);

insert into t2 values(1,2,1),(1,2,NULL);

update statistics on t1, t2;

select /*+ recompile */ * from t1 , t2 where t1.i=t2.i and t1.j=t2.j order by 1,2,3,4,5;

select /*+ recompile */ * from t1 , t2 where t1.i=t2.i and t1.j=t2.j;

drop table t2;
drop table t1;

set system parameters 'dont_reuse_heap_file=no';
