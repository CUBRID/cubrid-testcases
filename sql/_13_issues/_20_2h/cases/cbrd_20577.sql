drop table if exists t1;

create table t1 (f1 int, f2 int);
insert into t1 values(1,1);
insert into t1 values(2,null);
insert into t1 values(2,null);
insert into t1 values(2,3);
insert into t1 values(2,2);
select f1, f2 idx from t1 order by nvl(idx, 4);
drop table t1;

