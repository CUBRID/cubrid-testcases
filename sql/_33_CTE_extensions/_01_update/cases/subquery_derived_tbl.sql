drop table if exists t1,t2;
create table t1(i int ,j int,k int);
insert into t1 values(1,2,3);
insert into t1 values(1,4,6);

create table t2(i int ,j int);
insert into t2 values(1,2);

drop table if exists yoo;
create table yoo as
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select sum(n) as a from 
(
 select j from cte1 where k=6
 union all
 select j from cte2 where i=1
) as t(n);

select * from yoo order by 1;


with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
delete from yoo where a  in (select sum(n) from
(
 select j from cte1 where k=6
 union all
 select j from cte2 where i=1
) as t(n) );
select * from yoo order by 1;

insert into yoo
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select sum(n) as a from
(
 select j from cte1 where k=6
 union all
 select j from cte2 where i=1
) as t(n);

replace into yoo
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select sum(n) as a from
(
 select j from cte1 where k=6
 union all
 select j from cte2 where i=1
) as t(n);

select * from yoo order by 1;

with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
update yoo set a=a-20 where a=(select sum(n) as a from
(
 select j from cte1 where k=6
 union all
 select j from cte2 where i=1
) as t(n));

select * from yoo order by 1;

with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
update yoo set a=a+20 where a<(select sum(n) as a from
(
 select j from cte1 where k=6
 union all
 select j from cte2 where i=1
) as t(n));

select * from yoo order by 1;

drop if exists yoo,t1,t2;
