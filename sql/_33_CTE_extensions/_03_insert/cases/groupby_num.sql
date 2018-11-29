drop table if exists t;
create table t(i int,j varchar(10));
insert into t values(1,'a');
insert into t values(2,'b');
insert into t values(2,'c');
insert into t values(1,'c');
insert into t values(3,'a');
insert into t values(3,'c');

drop table if exists foo;
create table foo as
with cte as
(
 select groupby_NUM(), j from t group by i having groupby_NUM() between 1 and 5
) select * from cte  where rownum<4;

select * from foo order by 1,2;

insert into foo
with cte as
(
 select groupby_NUM(), j from t group by i having groupby_NUM() between 1 and 2
) select * from cte  where rownum<4;
select * from foo order by 1,2;


replace  into foo
with cte as
(
 select groupby_NUM(), j from t group by i having groupby_NUM() between 2 and 3
) select * from cte  where rownum<4;
select * from foo order by 1,2;


with cte as
(
 select groupby_NUM(), j from t group by i having groupby_NUM() between 2 and 3
) delete from foo where j not in (select j  from cte);

select * from foo order by 1,2;


with cte as
(
 select groupby_NUM(), j from t group by i having groupby_NUM() between 2 and 3
) update foo set j=-1 where j>any(select j  from cte);

select * from foo order by 1,2;

drop table if exists foo,t;
