create table t1(a int);
insert into t1 values(1), (2), (3);

create table t2(a int);
insert into t2 values(1), (2);

create view v1 as select * from t1 where a in(1, 3);
create view v2 as select * from t2 where a < 2;
select * from v1 left outer join v2 on v1.a=v2.a order by v1.a;
delete v1,v2 from v1 left outer join v2 on v1.a=v2.a;
drop view v1, v2;
drop table t1,t2;


