drop table if exists t,foo;
create table t(i int primary key,j varchar(50));

insert into t(i) values(1),(5);

drop view if exists v;
create view v as select * from t;

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
) select a,other_i from v,t,cte where other_i between v.i and t.i;
select * from foo order by 1,2;



with cte as
(
 select avg(i) as a,avg(i) as other_i from t
 union all
 select sum(i) as a ,sum(i) as other_i from t
 union all
 select count(i) as a,count(i) as other_i from t
 union all
 select median(i) as a,median(i) as other_i from t
) delete from foo;
select * from foo order by 1,2;

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
) select a,other_i from v,t,cte where other_i between v.i and t.i;
select * from foo order by 1,2;


drop if exists foo,t,v;
