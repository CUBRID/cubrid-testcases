drop table if exists t;
create table t(i int unique,j int default 0);
insert into t values(1,-1),(2,-2);

replace into t(i) values(1);
select * from t;


replace into t(i) 
with cte as
(
 select j from t
) select j from cte;


