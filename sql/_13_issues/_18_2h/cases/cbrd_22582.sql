drop table if exists foo,foo1;
create table foo (i int) 
partition by range(i) 
(
partition p1 values less  than(100),
partition p2 values less  than(2000)
);


drop table foo;
create table foo (i int) 
partition by range(i) 
(partition p1 values less  than(100),
partition p2 values less  than(2000)
)  as 
WITH cte AS 
(
select 1
)
select count(*) as cnt from cte;


create table foo1 (i int) 
partition by range(i) 
(partition p1 values less  than(100),
partition p2 values less  than(2000)
)  as 
WITH cte AS 
(
select * from _db_partition order by pname
)
select count(*) as cnt from cte;


insert into foo
with cte as
(
 select avg(cnt) as col2 from foo1
) select rownum, col2 from cte;
select * from foo order by 1,2;


replace into foo
with cte as
(
 select avg(cnt) as col2 from foo1
) select rownum, col2 from cte;
select * from foo order by 1,2;

insert into foo1
with cte1 as
(
 select avg(cnt) as col2 from foo
),
cte2 as
(
  select median(cnt) as col3 from foo1
)
select col2, col3 from cte1,cte2;
select * from foo1 order by 1,2;

with cte1 as
(
 select avg(cnt) as col2 from foo
), 
cte2 as
(
  select median(cnt) as col3 from foo
) delete foo where exists (
select col2, col3 from cte1,cte2);
select * from foo order by 1,2;

with cte1 as
(
 select avg(cnt) as col2 from foo
),
cte2 as
(
  select median(cnt) as col3 from foo
) update foo1 set i=-1 where exists (
select col2, col3 from cte1,cte2);
select * from foo1 order by 1,2;
drop table if exists foo,foo1;


drop if exists t1;

create table t1(i int);

insert into t1 values(1);

create table foo(i int) partition by range(i) (partition p1 values less  than(100),partition p2 values less  than(2000))  as WITH cte AS
(
select count(x.*) from (select * from t1)x
)
select count(*) from cte;

--CBRD-22582,disable count(tmp.*)
with tmp as (select * from t1)select count(tmp.*) from tmp;

with tmp as (select count(x.*) from (select * from foo) x) select *from tmp;

drop if exists t1,foo;
