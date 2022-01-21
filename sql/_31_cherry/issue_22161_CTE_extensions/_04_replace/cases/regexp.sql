drop table if exists testt,foo,foo2;
create table testt(id int,v varchar(20),f float, c varchar(10));
insert into testt values(NULL,'abc',5.64,'45d');
insert into testt values(NULL,'45d',-3.44,'df');
create table foo as
with cte as
(
select /*+ recompile */ * from testt where (select ('aaa' regexp 'a{6,}'))<>0 order by 2
) select *from cte;

insert into foo
with cte as
(
select /*+ recompile */ * from testt where (select (not 'aaa' regexp 'a{6,}'))<>0 order by 2
) select *from cte;

replace into foo
with cte as
(
select /*+ recompile */ * from testt where (select (not 'aaa' regexp 'a{6,}'))<>0 order by 2
) select *from cte;

select * from foo order by 1,2,3,4;

create table foo2 as
with cte as
(
select /*+ recompile */ * from testt where (select ('aaa' not regexp 'a{6,}'))<>0 order by 2
) select *from cte;


with cte as
(
select /*+ recompile */ * from testt where (select 1)<>0 order by 2
) delete from foo,foo2 using foo,foo2,cte where foo.v=foo2.v and foo2.f=cte.f;

select * from foo2 order by 1,2,3,4;
select * from foo order by 1,2,3,4;

insert into foo
with cte as
(
select /*+ recompile */ * from testt where (select ('aaa' like 'bbb'))<>0 order by 2
)select *from cte;
select * from foo order by 1,2,3,4;

replace into foo2
with cte as
(
select /*+ recompile */ * from testt where (select ('aaa' like 'aaa'))<>0 order by 2
)select *from cte;
select * from foo2 order by 1,2,3,4;

replace into foo2
with cte as
(
select /*+ recompile */ * from testt where (select ('aaa' not like 'aaa'))<>0 order by 2
)select *from cte;

select * from foo2 order by 1,2,3,4;

drop table if exists foo,foo2, testt;
