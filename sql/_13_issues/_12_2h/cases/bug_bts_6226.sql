drop table if exists t1;
create table t1 (a int primary key);
insert into t1 values (1), (2);
select * from t1 where a < 2;
select * from t1 where a < 3;
select 1;
drop table if exists t1;
