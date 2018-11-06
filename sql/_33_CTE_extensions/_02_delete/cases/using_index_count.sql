drop table if exists t,foo,bar;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table foo ( i int, j int, k int);
insert into foo values(1,1,1);
create table bar(i int primary key);
insert into bar values(1);
set optimization level 513;
WITH mycte(a,b,c,d) AS
(
select * from bar, foo where bar.i in(foo.i, foo.j, foo.k) using index bar.pk_bar_i(+)
)
delete from t where i <=(select count(*) from mycte);

drop foo;
drop bar;

create table aaa(a integer);
insert into aaa values(1);
create index idx1 on aaa(a);
WITH mycte AS
(
select rownum, a from aaa where a in(1,1,1) using index idx1(+)
)
delete from t where i <=(select count(*) from mycte);
drop aaa;
