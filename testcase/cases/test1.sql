drop table if exists t1,foo,foo1,foo2,foo3,foo4;
create table t1 (a varchar(10));
insert into t1 values ('a');

create table foo1 as WITH cte AS
(
select 'hello', min(a) a, b from t group by b order by a,b DESC limit 5
)
select * from cte;
create table foo2 as WITH cte AS
(
select 'hello', a , min(b) b from t group by a order by a,b DESC limit 5
)
select * from cte;
create table foo3 as WITH cte AS
(
select sum(b) from t group by b order by a,b DESC limit 5
)
create table foo4 as WITH cte AS
(
SELECT ((CAST ({3,3,3,2,2,1} AS LIST))-(CAST ({4,3,3,2} AS MULTISET)))
)
select * from cte;
select * from foo;
select * from foo1;
select * from foo2;
select * from foo3;
select * from foo4;
drop table if exists t1,foo,foo1,foo2,foo3,foo4;
