set system parameters 'dont_reuse_heap_file=yes';

create table t1(a int , b int);
create table t2(a int , b int);
create view v1 as select * from t1;
create view v2 as select * from t2;

insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (6,6),(4,4),(3,3),(2,2),(1,1);
select * from v1 left join v2 on v1.a=v2.a where v2.a is null;
update  v1 left join v2 on v1.a=v2.a set v2.a=999, v1.a=1000 where v2.a is null or v2.a>3;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
drop table t1;
drop table t2;
drop view v1;
drop view v2;


create table t1(a int , b int);
create table t2(a int , b int);
create view v1 as select * from t1;
create view v2 as select * from t2;
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (6,6),(4,4),(3,3),(2,2),(1,1);
select * from v1 left join v2 on v1.a=v2.a where v2.a is null;
update  v1 left join v2 on v1.a=v2.a set v1.a=(select count(*) from t2) where v2.a is null or v2.a>3;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
drop table t1;
drop table t2;
drop view v1;
drop view v2;

create table t1(a int , b int);
create table t2(a int , b int);
create view v1 as select * from t1;
create view v2 as select * from t2;
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (6,6),(4,4),(3,3),(2,2),(1,1);
select * from v1 left join v2 on v1.a=v2.a where v2.a is null;
update  v1 left join v2 on v1.a=v2.a set v1.a=(select count(*) from t2 where v1.a=t2.a) where v2.a is null or v2.a>3;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
drop table t1;
drop table t2;
drop view v1;
drop view v2;



create table t1(a int , b int);
create table t2(a int , b int);
create view v1 as select * from t1;
create view v2 as select * from t2;
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (6,6),(4,4),(3,3),(2,2),(1,1);
update  v1 left join v2 on v1.a=v2.a set v1.a=(select max(a) from t1), v2.a=(select min(a) from t2);
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
drop table t1;
drop table t2;
drop view v1;
drop view v2;



create table t1(a int , b int);
create table t2(a int , b int);
create view v1 as select * from t1;
create view v2 as select * from t2;
insert into t1 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (6,6),(4,4),(3,3),(2,2),(1,1);
update  t2 left join v2 on t2.a=v2.a set v2.a=10, t2.b=(select count(*) from t2 where t2.a = v2.a);
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
select * from v1 order by 1, 2;
select * from v2 order by 1, 2;
drop table t1;
drop table t2;
drop view v1;
drop view v2;



create table t1(a int , b int, index i_t1_a (a) where a>1 );
create table t2(a int , b int, index i_t2_a (a) where a>1 );
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (5,5),(4,4),(3,3),(2,2),(1,1);
select * from t1 left join t2 on t2.a=t1.a where t1.a>0 and t2.a >0  using index i_t1_a, i_t2_a;
update /*+ recompile */ t1 left join t2 on t2.a=t1.a set t1.a=t2.a+1000, t1.b=t2.b+2000, t2.a=t1.a+3000, t2.b=t1.b+4000 where t1.a>0 and t2.a >0 and t2.a%2=0 using index i_t1_a, i_t2_a;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;




create table t1(a int , b int, index i_t1_a (a) where a>1 );
create table t2(a int , b int, index i_t2_a (a) where a>1 );
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (5,5),(4,4),(3,3),(2,2),(1,1);
select * from t1 left join t2 on t2.a=t1.a where t1.a>0 and t2.a >0  using index i_t1_a, i_t2_a;
update /*+ recompile */ t1 left join t2 on t2.a=t1.a set t1.a=t2.a+1000, t1.b=t2.b+2000, t2.a=t1.a+3000, t2.b=t1.b+4000 where t1.a>0 and t2.a >0 and t2.a%2=0 using index i_t1_a keylimit 0,1, i_t2_a keylimit 1,1;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;

create table t1(a int , b int, index i_t1_a (a) where a>1 );
create table t2(a int , b int, index i_t2_a (a) where a>1 );
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);
insert into t2 values (5,5),(4,4),(3,3),(2,2),(1,1);
insert into t1 select rownum, rownum from t1, t1 t1_1;
insert into t1 select rownum, rownum from t1, t1 t1_1;
insert into t1 select rownum, rownum from t1;
insert into t2 select rownum, rownum from t1;
select * from t1 left join t2 on t2.a=t1.a where t1.a>0 and t2.a >0 and t2.a%2=0 using index i_t1_a keylimit 0,100, i_t2_a keylimit 0,100;
update /*+ recompile */ t1 left join t2 on t2.a=t1.a set t1.a=t2.a+1000, t1.b=t2.b+2000, t2.a=t1.a+3000, t2.b=t1.b+4000 where t1.a>0 and t2.a >0 and t2.a%2=0 using index i_t1_a keylimit 0,100, i_t2_a keylimit 0,100;
select * from t1 order by 1,2 limit 10;
select * from t2 order by 1,2 limit 10;
drop table t1;
drop table t2;




create table t1(a int, b int, index i_t1_a (a) where a>2);
create table t2(a int, b int, index i_t2_a (a) where a>2);
insert into t1 values (2,2);
insert into t2 values (2,2);
create trigger tri_t1_after_update before update on t1 execute insert into t2 values (4,4), (1,1); 
select * from t1 order by 1,2;
select * from t2 order by 1,2;
update t1 join t2 on t1.a=t2.a set t1.a=3, t2.a=3 where t1.a>0 and t2.a>0 using index i_t1_a, i_t2_a;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;



create table t1(a int, b int, index i_t1_a (a) where a>2);
create table t2(a int, b int, index i_t2_a (a) where a>2);
insert into t1 values (2,2);
insert into t2 values (2,2);
create trigger tri_t1_after_update after update on t1 execute insert into t2 values (4,4), (1,1); 
select * from t1 order by 1,2;
select * from t2 order by 1,2;
update t1 join t2 on t1.a=t2.a set t1.a=3, t2.a=3 where t1.a>0 and t2.a>0 using index i_t1_a, i_t2_a;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;



create table t1(a int, b int, index i_t1_a (a) where a>2);
create table t2(a int, b int, index i_t2_a (a) where a>2);
insert into t1 values (2,2);
insert into t2 values (2,2);
create trigger tri_t1_after_update after update on t1 execute insert into t1 values (4,4), (1,1); 
update t1 set t1.a=3 where t1.a>0 using index i_t1_a;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;




create table t1(a int, b int, index i_t1_a (a) where a>2);
create table t2(a int, b int, index i_t2_a (a) where a>2);
insert into t1 values (2,2);
insert into t2 values (2,2);
create trigger tri_t1_after_update before update on t1 execute insert into t1 values (4,4), (1,1); 
update t1 set t1.a=3 where t1.a>0 using index i_t1_a;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;



create table t1(a int, b int, index i_t1_a (a) where a>2 and a<10);
create table t2(a int, b int, index i_t2_a (a) where a>2 and a<10);
insert into t1 values (2,2), (4,4);
insert into t2 values (2,2), (4,4);
create trigger tri_t1_after_update after update on t1 execute insert into t2 values (5,5), (1,1);
create trigger tri_t1_before_update before update on t1 execute insert into t1 values (5,5), (1,1);
update t1 join t2 on t1.a=t2.a set t1.a=999, t2.a=999 where t1.a>0 and t2.a>0 using index i_t1_a keylimit 0,2, i_t2_a keylimit 0, 2;
select * from t1 where a>0 using index i_t1_a order by 1,2;
select * from t2 where a>0 using index i_t2_a order by 1,2;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;





create table t1(a int, b int, index i_t1_a (a));
create table t2(a int, b int, unique index i_t2_a (a));
insert into t1 values (2,2), (4,4);
insert into t2 values (2,2), (4,4);
create trigger tri_t1_after_update after update on t1 execute insert into t2 values (5,5), (1,1);
create trigger tri_t1_before_update before update on t1 execute insert into t1 values (5,5), (1,1);
update t1 join t2 on t1.a=t2.a set t1.a=999, t2.a=999 where t1.a>0 and t2.a>0 using index i_t1_a keylimit 0,2, i_t2_a keylimit 0, 2;
select * from t1 where a>0 using index i_t1_a order by 1,2;
select * from t2 where a>0 using index i_t2_a order by 1,2;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;




create table t1(a int, b int, unique index(a));
create table t2(a int, b int, index i_t2_a (a));
create table t3(a int, b int);
insert into t1 values (1,1);
insert into t2 values (1,1);
insert into t3 select rownum, rownum from db_class s1, db_class s2, db_class s3 limit 1000;
create trigger tri_t3_before_update before update on t3 execute update t1, t2 set t1.a=t1.a+1, t2.a=t2.a+1 where t1.a>0 and t2.a>0;
create trigger tri_t3_after_update after update on t3 execute update t2, t1 set t2.a=t2.a+1, t1.a=t1.a+1 where t1.a>0 and t2.a>0;
update t3 set a=0, b=0;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
select * from t3 order by 1,2 limit 1;
drop table t1;
drop table t2;
drop table t3;



set system parameters 'dont_reuse_heap_file=no';

