drop table if exists t,foo;
create table t(i int primary key,j varchar(50));

insert into t(i) values(1),(5);

create table foo as
with cte as
(select * from v)
select * from cte;


insert into foo
with cte as
(
 select avg(i) as a,avg(i) as other_i from t 
 union all
 select sum(i) as a ,sum(i) as other_i from t
 union all 
 select count(i) as a,count(i) as other_i from t
 union all
 select median(i) as a,median(i) as other_i from t
) select a,other_i from t,cte where other_i >= t.i;
select * from foo;



with cte as
(
 select avg(i) as a,avg(i) as other_i from t
 union all
 select sum(i) as a ,sum(i) as other_i from t
 union all
 select count(i) as a,count(i) as other_i from t
 union all
 select median(i) as a,median(i) as other_i from t
) delete foo from foo, t,cte where other_i >= t.i;

select * from foo;



replace into foo
with cte as
(
 select avg(i) as a,avg(i) as other_i from t
 union all
 select sum(i) as a ,sum(i) as other_i from t
 union all
 select count(i) as a,count(i) as other_i from t
 union all
 select median(i) as a,median(i) as other_i from t
) select a,other_i from t,cte where other_i >= t.i;
select * from foo;
