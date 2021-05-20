drop table if exists t;
create table t(i int,j varchar(10));
insert into t values(1,'a');
insert into t values(2,'b');
insert into t values(1,'c');
insert into t values(3,'a');

drop table if exists foo;
create table foo as
with cte as
(
 select ORDERBY_NUM() as [orderby_num()], j from t order by 2 for ORDERBY_NUM() between 3 and 5
) select * from cte  where rownum<2;

select * from foo order by 1,2;

insert into foo
with cte as
(
 select ORDERBY_NUM() as [orderby_num()], j from t order by 2 for ORDERBY_NUM() between 1 and 5
) select * from cte  where rownum<2;

select * from foo order by 1,2;


replace  into foo
with cte as
(
 select ORDERBY_NUM() as [orderby_num()], j from t order by 2 for ORDERBY_NUM() between 2 and 5
) select * from cte  where rownum<2;
select * from foo order by 1,2;

with cte as
(
 select j from t where i=1 order by 1
),
cte2 as (
select * from cte  where rownum<2
) delete from foo where j in (select j  from cte2);

select * from foo order by 1,2;



with cte as
(
 select j from t where i=1 order by 1
),
cte2 as (
select * from cte  where rownum<2
) update foo set j=-1 where j>any(
select j from cte2
);

select * from foo order by 1,2;

drop table if exists foo,t;
