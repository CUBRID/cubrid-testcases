drop table if exists t1;
create table t1(a int , b int, index i (a));
create view v1 as select * from t1;
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);
update t1 left join v1 on t1.a=v1.a set v1.a=t1.b, t1.b=v1.a where t1.a>0;

drop table if exists t1;
drop view v1;

create table t1(a int , b int, index i (a));
create view v1 as select * from t1;
insert into t1 values (6,6),(4,4),(3,3),(2,2),(1,1);
--below will be blocked.
update /*+ recompile */ t1 left join v1 on v1.a=t1.a set v1.a=100, t1.a=99 where t1.a>4 using index i;

drop table if exists t1;
drop view v1;

create table t1(a int, b int, index i (a,b));
create view v1 as select * from t1;
insert into t1 values (1,1), (2,2),(3,3);
--test: below statement will be blocked.
update t1 left join v1 on t1.a=v1.a set t1.b=100, v1.b=99 where v1.a in (2,3) and t1.a in (1,2);
select * from t1 order by 1, 2;

drop table if exists t1;
drop view v1;
