drop table if exists t1;
drop table if exists t2;

create table t1 (i1 int);
create table t2 (i1 int);
insert into t1 values(1);
insert into t2 values(1);
insert into t2 values(2);

select * from (select i1+1 from t1) t1;

select * from (select i1+1 from t1) t1 natural join (select i1+1 from t2) t2;

drop table t1;
drop table t2;
