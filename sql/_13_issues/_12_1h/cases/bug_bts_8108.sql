set system parameters 'create_table_reuseoid=no';
--TEST: [Multi-table Update] result is not correct when update a table and a view.


--case1
create table t1(a int, b int);
create view v1 as select * from t1 where a>3;
insert into v1 values (1,1), (3,3), (5,5);

update  t1 left join v1 on t1.a=v1.a set v1.a=1000;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;


--case2
create table t1(a int, b int);
create view v1 as select * from t1 where a>3;
insert into v1 values (1,1), (3,3), (5,5);

delete v1.* from  t1 left join v1 on t1.a=v1.a;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;


--case3
create table t1(a int , b int, index idx_t1(a));
create view v1 as select * from t1;
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);

update t1 left join v1 on t1.a=v1.a set v1.a=t1.b + 1, t1.b=v1.a - 1 where t1.a>0;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;


--case4
create table t1(a int , b int, index i_t1_a (a));
create view v1 as select * from t1;
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);

update t1 left join v1 on v1.a=t1.a set v1.a=100, t1.a=99 where t1.a>4 using index i_t1_a;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;


--case5
create table t1(a int, b int, index idx_t1(a,b));
create view v1 as select * from t1;
insert into t1 values (1,1), (2,2),(3,3);

update t1 left join v1 on t1.a=v1.a set t1.b=100, v1.b=99 where v1.a in (2,3) and t1.a in (1,2);
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;
set system parameters 'create_table_reuseoid=yes';
