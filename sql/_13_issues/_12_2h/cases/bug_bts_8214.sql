--TEST: [Analytic Functions] 'ERROR: System error (generate order_by) in ../../src/parser/xasl_generation.c (line: 5271)' error occurs when updating a column using analytic function with partition_by_clause.

drop table if exists t;

create table t(a int, b int);
insert into t values(1, 100), (2, 200), (3, 200);

--System error occurs
update t set a=max(a) over(partition by b);
select * from t order by 1, 2;
update t set a=max(a) over();
select * from t order by 1, 2;
update t set a=avg(a) over(partition by b);
select * from t order by 1, 2;
update t set a=sum(b) over(partition by b);
select * from t order by 1, 2;
update t set a=min(a) over(partition by b order by a);
select * from t order by 1, 2;
update t set a=stddev(a) over(partition by b order by a) where b=100;
select * from t order by 1, 2;
update t set a=stddev(b) over() where b=200;
select * from t order by 1, 2;


drop table t;
