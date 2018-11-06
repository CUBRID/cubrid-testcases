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
 select j from t where i=1 order by 1 
) select * from cte  where rownum<2;

select * from foo;

insert into foo
with cte as
(
 select j from t where i=1 order by 1
) select * from cte  where rownum<2;

select * from foo;

replace into foo
with cte as
(
 select j from t where i=1 order by 1
) select * from cte  where rownum<2;

select * from foo;

with cte as
(
 select j from t where i=1 order by 1
),
cte2 as (
select * from cte  where rownum<2
) delete from foo where j in (select * from cte2);

select * from foo;

replace into foo
with cte as
(
 select j from t where i=1 order by 1
),
cte2 as (
select * from cte  where rownum<2
) select * from cte
union all
select * from cte2;

select * from foo;


with cte as
(
 select j from t where i=1 order by 1
),
cte2 as (
select * from cte  where rownum<2
) update foo set j=-1 where j=any(
select j from cte2
);

select * from foo;
