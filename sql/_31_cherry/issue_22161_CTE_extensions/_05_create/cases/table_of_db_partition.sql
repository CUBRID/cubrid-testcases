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

describe foo;


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
describe foo1;
select * from foo1 order by 1,2;
drop table foo1;
create table foo1 (i int) 
as 
WITH cte AS 
(
select * from _db_partition order by pname
)
select count(*) as cnt from cte;
describe foo1;
select * from foo1 order by 1,2;
drop table if exists foo,foo1;
