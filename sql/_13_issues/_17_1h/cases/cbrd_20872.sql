with cte1(a) as (select 1 a),
cte2(a) as (select a + 1 from cte1)
select *from cte1 union all select *from cte2 order by 1;

with cte1(a) as (select 1 a),
cte2(a) as (select a from cte1)
select *from cte1 union all select *from cte2 order by 1;


with cte1(a) as (select 1 a),
cte2(a) as (select a + 1 from cte1)
select *from cte1 difference  select *from cte2 order by 1;

with cte1(a) as (select 1 a),
cte2(a) as (select a from cte1)
select *from cte1 difference select *from cte2 order by 1;

with cte1(a) as (select 1 a),
cte2(a) as (select a + 1 from cte1 union select 1 from db_class)
select *from cte1 intersection select *from cte2 order by 1;

with cte1(a) as (select 1 a),
cte2(a) as (select a+1 from cte1)
select *from cte1 intersection select *from cte2 order by 1;


values((select 1 from db_class));

drop table if exists t1;
create table t1(id int, name varchar);
insert into t1 values(1,'cte'),(2,'cbrd');
insert into t1 values(select * from t1);
insert into t1 select * from t1;

drop table if exists t1;

