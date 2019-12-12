drop class if exists Z, W,foo;

create class Z (zs string);

create class W (wz Z);

insert into W values (NULL);

insert into W values (NULL);

create table foo (i int) partition by range(i) (partition p1 values less  than(100),partition p2 values less  than(2000))  as WITH cte AS
(
select /*+ RECOMPILE */ *  from W where wz.zs is null
)
select count(*) from cte;

drop table foo;
create table foo  as WITH cte AS
(
select /*+ RECOMPILE */ *  from W where wz.zs is null
)
select count(*) from cte;

drop table foo;
create table foo(i int)  as WITH cte AS
(
select /*+ RECOMPILE */ *  from W where wz.zs is null
)
select count(*) from cte;

drop class if exists Z, W,foo;
