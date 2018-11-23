drop table if exists t,foo;
create table t(i int primary key,j varchar(50),k double);
insert into t values(1,'A',95);
insert into t values(2,'A',91);

create table foo as select * from t;
replace into t set i=3 ,j='A', k=(with cte as (select avg(k) as avg_k from t group by j) select avg_k  from cte);
select * from t;



insert into t set i=4 ,j='A', k=(with cte as (select avg(k) as avg_k from t group by j) select avg_k  from cte);
select * from t;
