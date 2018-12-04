drop table if exists t;
create table t(i int unique)
partition by range(i)
(
partition before_2000 values less than (2000),
partition before_4000 values less than (4000)
);
insert into t values(1999),(2001);

drop table if exists foo;
create table foo as
with cte as
(
select * from t where i >2000
) select * from cte;

alter table foo change column i i int unique;
insert into foo
with cte as
(
 select * from t__p__before_4000
),
cte1 as
(
select * from t__p__before_2000
)select * from cte
union all
select * from cte1 on duplicate key update i=i+10;

select * from foo order by 1;



with cte as
(
select * from t where i >2000
) delete from foo where i in (select i from t);
select * from foo order by 1;

insert into  foo
with cte as
(
 select * from t__p__before_4000
),
cte1 as
(
select * from t__p__before_2000
)select * from cte
union all
select * from cte1 on duplicate key update i=i+10;

select * from foo order by 1;


with cte as
(
select * from t where i >2000
) delete from foo where i in (select i from t);
select * from foo order by 1;

--CBRD-22567
insert into  foo
with cte as
(
 select * from t__p__before_4000
),
cte1 as
(
select * from t__p__before_2000
)select * from cte
union all
select * from cte1 on duplicate key update i=(select i-10 from cte);

select * from foo order by 1;


drop table if exists foo,t;
