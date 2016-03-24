--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';


create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>3 set t1.a=t2.a where t1.a>0 using index i_t1_a, i_t2_a keylimit 0,2;
select * from t1 order by 1,2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>10000 set t1.a=t2.a, t1.b=100 where t1.a>1 using index i_t1_a keylimit 0,2, i_t2_a keylimit 0,1;
select * from t1 order by 1,2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>0 and t1.a>0 set t1.a=t2.a, t1.b=100, t2.b=100 where t1.a>0 using index i_t1_a keylimit 0,0, i_t2_a keylimit 0,1;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>2 and t1.a>0 set t1.a=t2.a, t1.b=100, t2.b=100 where t1.a>0 using index i_t1_a keylimit 0,4, i_t2_a keylimit 0,4;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;



create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>2 set t1.b=100, t2.b=100 where t1.a>2 using index i_t1_a keylimit 1,1, i_t2_a keylimit 0,1;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;



create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>2 set t1.b=100, t2.b=100 where t1.a>2 using index i_t1_a keylimit 0,0, i_t2_a keylimit 0,1;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create view t2 as select * from t1;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>2 set t1.b=100, t2.b=100 where t1.a>2 using index i_t1_a keylimit 0,0;
select * from t1 order by 1,2;
drop table t1;
drop view t2;

create table t1(a int, b int);
create view t2 as select * from t1;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>2 set t1.b=100, t2.b=100 where t1.a>1 using index i_t1_a keylimit 1,2;
select * from t1 order by 1,2;
drop table t1;
drop view t2;



create table t1(a int, b int);
create view t2 as select * from t1;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>9999 set t1.b=100 where t1.a>1 using index i_t1_a keylimit 1,2;
select * from t1 order by 1,2;
drop table t1;
drop view t2;


create table t1(a int, b int);
create view t2 as select * from t1;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
create index i_t1_a on t1(a);
update /*+ recompile */ t1 left join t2 on t1.a=t2.a and t2.a>9999 set t2.b=100 where t1.a>1 using index i_t1_a keylimit 1,2;
select * from t1 order by 1,2;
drop table t1;
drop view t2;




create table t1(a int, b int);
create view t2 as select 1 a, 1 b from t1;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
update /*+ recompile */ t1,t2,t1 aaa set t1.b=100, t1.a=t2.a,t2.a=t1.a, t2.b=100 where t1.a=t2.a ;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop view t2;



create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t2 values (1,1),(2,2),(3,3),(4,4);
prepare stmt from 'update /*+ recompile */ t1,t2,t1 aaa set t1.b=?, t1.a=t2.a,t2.a=t1.a, t2.b=100 where t1.a=t2.a ';
execute stmt using 1000;
deallocate prepare stmt;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;

create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 select rownum, rownum from db_class s1, db_class s2, db_class s3, db_class s4 limit 100000;
insert into t2 values (4,4),(3,3),(2,2),(1,1);
update t1, t2 set t1.b=100 where t1.a%4+1 in (select a from t2);
select count(*) from t1 where b=100;
drop table t1;
drop table t2;




create table t1(a int unique, b int);
create table t2(a int unique, b int);
insert into t1 values (4,4),(3,3),(2,2),(1,1);
insert into t2 values (4,4),(3,3),(2,2),(1,1);
update t1,t2 set t2.a=3 where t2.a=t1.a and t1.a=4;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
create index i1 on t1(t1.a, t1.b);
create index i2 on t2(t2.a, t2.b);
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (4,4),(3,3),(2,2),(1,1);
update t1 left join t2 on t1.a=t2.a set t2.a=t1.a, t1.a=100 where t2.a is null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
create index i1 on t1(t1.a, t1.b);
create index i2 on t2(t2.a, t2.b);
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (4,4),(3,3),(2,2),(1,1);
update t1 left join t2 on t1.a=t2.a set t2.a=100, t1.a=100 where t2.a is not null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;

create table t1(a int, b int);
create table t2(a int, b int);
create index i1 on t1(t1.a, t1.b);
create index i2 on t2(t2.a, t2.b);
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (4,4),(3,3),(2,2),(1,1);
update t1 left join t2 on t1.a=t2.a set t1.a=t2.a, t2.a=t1.a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create view v1 as select * from t1 where a>3;
insert into v1 values (1,1), (3,3), (5,5);
update v1 set a=100;
select * from t1 order by a;
drop table t1;
drop view v1;



create table t1(a int primary key, b int);
create table t2(a int primary key, b int);
create view v2 as select * from t2;
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (6,6),(4,4),(3,3),(2,2),(1,1);
--update  t1 left join v2 on t1.a=v2.a set v2.a=1000, t1.a=4 where v2.a is null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
select * from v2 order by 1, 2;
drop table t1;
drop table t2;
drop view v2;

set system parameters 'dont_reuse_heap_file=no';

--+ holdcas off;
