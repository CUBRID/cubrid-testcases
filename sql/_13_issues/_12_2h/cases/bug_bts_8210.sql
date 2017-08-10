--TEST: [Analytic Functions] 'ERROR: System error (generate attr) in ../../src/parser/xasl_generation.c (line: 9498)' occurs when updating a column with analytic function.


drop table if exists t;

create table t(a int);
insert into t values(1), (2), (3);

--[er]
update t set a=(select avg(a) over() from t);
update t set a=(select count(a) over(order by a) from t);
update t set a=(select sum(a) over(partition by a) from t);
update t set a=(select var_pop(a) over(partition by a order by a) from t);

--success
update t set a=(select max(a*100) over() from t where a=2) where a=1;


select * from t order by 1;

drop table t;

