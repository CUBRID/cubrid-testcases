drop table if exists t;
create table t(i int unique,j int auto_increment);
insert into t values(1,-1),(2,-2);

replace into t(i) values(1);
select * from t order by 1,2;

replace into t(i) 
with cte as
(
 select j from t order by 1
) select j from cte;
select * from t order by 1,2;


insert into t(i)
with cte as
(
 select j from t order by 1
) select j from cte on duplicate key update i=i+100;

select * from t order by 1,2;



with cte as
(
 select i from t
),
cte2 as
(
 select j from t order by 1
)
update t,cte,cte2 set t.j=-100 where cte.i=cte2.j and t.i=cte.i;
select * from t order by 1,2;



with cte as
(
 select i from t
),
cte2 as
(
 select j from t order by 1
)
select t.* from t,cte,cte2 where cte.i=cte2.j and t.i=cte.i;

with cte as
(
 select i from t
),
cte2 as
(
 select j from t order by 1
)
delete from t using t,cte,cte2 where cte.i=cte2.j and t.i=cte.i;
select * from t order by 1,2;


with cte as
(
 select i from t
),
cte2 as
(
 select j from t order by 1
)
update t,cte,cte2 set t.j=-1 where cte.i=cte2.j;
select * from t order by 1,2;

drop table if exists t;
