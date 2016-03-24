--CLIENT
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create view v1 as select t1.i as t1i, t2.i as t2i from t1 inner join t2 on t1.i=t2.i where t1.i > 3;
create view v2 as select * from t1 where i < 5;

update t1, v1, t2, v2 set v1.t1i=3, v2.i=4, t1.i=5, t2.i=6;

drop view v1;
drop view v2;
drop table t1;
drop table t2;