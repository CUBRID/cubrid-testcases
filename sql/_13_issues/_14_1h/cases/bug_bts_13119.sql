drop table if exists t1;
create table t1(a int);
insert into t1 values(1);
select t1.identity from t1;
drop table if exists t1;
