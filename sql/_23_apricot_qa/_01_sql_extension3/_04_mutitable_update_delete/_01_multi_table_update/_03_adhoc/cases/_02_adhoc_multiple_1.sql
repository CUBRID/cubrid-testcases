set system parameters 'create_table_reuseoid=no';
set system parameters 'dont_reuse_heap_file=yes';


create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
update t1, t2 set t1.a=t1.a+100, t2.a=t2.a+100 where t1.a=t2.a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
update t1, t2 set t1.a=t1.a-100, t2.a=t2.a-100 where t1.a=t2.a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
update t1, t2 set t1.a=t1.a+100, t2.a=t1.a+100 where t1.a=t2.a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
update t1, t2 set t1.a=t1.a+100, t2.a=t1.a+100, t2.a=t1.a-100 where t1.a=t2.a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
update t1, t2 set t1.a=t1.a+100, t2.a=t1.a+100  where t1.a=t2.a limit 100;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
update t1 set a=100 order by a desc;
update t1, t2 set t1.a=t1.a+100, t2.a=t1.a+100  where t1.a=t2.a order by a desc;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update t1, t2 set t1.a=t1.a+100, t2.a=t1.a+100  where t1.a=t2.a using index i_t1_a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2), (2,2,2);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1, t2 set t1.a=t1.a+100, t2.a=t1.a+100  where t1.a=t2.a using index i_t2_a keylimit 0,1;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
create index i1 on t1(a);
create index i2 on t2(a);
update /*+ recompile */ t1, t2 set t1.a=default;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;



create table t1(a varchar(100) default USER, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values ('1',1,1), ('2',2,2);
insert into t2 values (1,1,1), (2,2,2);
create index i1 on t1(a);
create index i2 on t2(a);
update /*+ recompile */ t1, t2 set t1.a=default;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;




create table t1(a int, b int, c int);
create table t2(a int, b int ,c int);
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
create index i1 on t1(a);
create index i2 on t2(a);
update /*+ recompile */ t1, t2 set t1.a=t1.b ,t1.b=t1.c , t1.c=t2.a , t2.a=t2.b , t2.b=t2.c, t2.c=t1.a where t1.a=t2.a and t1.a=1;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;



create table s1(a int, b int, c int);
create table s2(a int, b int ,c int);
create view t1 as select * from s1;
create view t2 as select * from s2;
insert into t1 values (1,1,1), (2,2,2);
insert into t2 values (1,1,1), (2,2,2);
create index i1 on t1(a);
create index i2 on t2(a);
update /*+ recompile */ t1, t2 set t1.a=t1.b ,t1.b=t1.c , t1.c=t2.a , t2.a=t2.b , t2.b=t2.c, t2.c=t1.a where t1.a=t2.a and t1.a=1;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop view t1;
drop view t2;
drop table s1;
drop table s2;


create table t1(a int, b int);
create view v1 as select * from t1 order by a asc;
insert into t1 values (1,1),(2,2),(3,3), (4,4);
update t1, v1 set v1.a=t1.a where t1.a=v1.a;
select * from t1 order by 1,2;
drop table t1;
drop view v1;


create table t1(a int, b int);
create view v1 as select * from t1 where a=1 order by a asc ;
insert into t1 values (1,1),(2,2),(3,3), (4,4);
update t1, v1 set t1.a=-v1.a where t1.a=1;
select * from t1 order by 1,2;
drop table t1;
drop view v1;



create table t1(a int, b int);
create view v1 as select * from t1 where a=1 order by a asc ;
insert into t1 values (1,1),(2,2),(3,3), (4,4);
update t1, v1 set t1.a=v1.a;
select * from t1 order by 1,2;
drop table t1;
drop view v1;



create table t1(a int, b int);
create view v1 as select * from t1 where a=1 order by a asc ;
insert into t1 values (1,1),(2,2),(3,3), (4,4);
update t1, v1 set t1.a=v1.a where t1.a=1 and v1.a=1;
update t1, v1 set t1.a=v1.a where t1.a=2 and v1.a=2;
update t1, v1 set t1.a=v1.a where t1.a=3 and v1.a=3;
update t1, v1 set t1.a=v1.a where t1.a=4 and v1.a=4;
select * from t1 order by 1,2;
drop table t1;
drop view v1;



create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t1.a>0 and t2.a>555 set t1.a=t2.a;
select * from t1 order by 1,2;
drop table t1;
drop table t2;



create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
select * from t1 left join t2 on t1.a=t2.a where t1.a>555 and t2.a>555;
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>555 set t1.a=t2.a where t1.a>555 and t2.a>555;;
select * from t1 order by 1,2;
drop table t1;
drop table t2;

set system parameters 'dont_reuse_heap_file=no';
set system parameters 'create_table_reuseoid=yes';
