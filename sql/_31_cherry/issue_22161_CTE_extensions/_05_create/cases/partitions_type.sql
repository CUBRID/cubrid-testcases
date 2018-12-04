drop table if exists t,foo;
create table t(i int,j int);
insert into t(i) values(1),(15);

create table foo(i int)
partition by range(i)
(partition p1 values less  than(10),
partition p2 values less  than(20)) as
with cte as
(
select i from t
) select * from cte;

select * from foo order by 1;



drop table foo;
create table foo(i int)
partition by list(i)
(partition p1 values in (1,3),
partition p2 values in (15,25)) as
with cte as
(
select i from t
) select * from cte;

select * from foo order by 1;

drop table foo;

create table foo(i int)
partition by hash(i)
partitions 5 as
with cte as
(
select i from t
) select * from cte;

select * from foo order by 1;

drop table if exists t, foo;
