WITH mycte(a) AS
(
select TIME '03:30:30 pm' + cast(1 as SHORT) from db_root
)
delete from t where i <=(select count(a) from mycte);

drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH mycte(a) AS
(
select TIME '03:30:30 pm' + cast(1 as SHORT) from db_root
)
delete from t where i <=(select count(*) from mycte);

drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH cte_z3uZpFTlA AS
(
select TIME '03:30:30 pm' + cast(1 as SHORT) from db_root
)
delete from t where i <=(select count(*) from cte_z3uZpFTlA);


drop table if exists foo,bar;
create table foo (i int, name varchar(10));
create table bar (i int, name varchar(10));
insert into foo values (1, 'a');
insert into foo values (1, 'b');
insert into foo values (1, 'c');
insert into foo values (2, 'e');
insert into bar values (1, 'x');
insert into bar values (4, 'w');

drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
set optimization level 513;
WITH mycte(a,b,c,d) AS
(
select /*+ RECOMPILE USE_MERGE */ * from foo right outer join bar on foo.i = bar.i order by 1,2
)
delete from t where i <=(select count(*) from mycte);

WITH mycte(a,b,c,d) AS
(
select /*+ RECOMPILE USE_NL */ * from foo right outer join bar on foo.i = bar.i order by 1,2
)
delete from t where i <=(select count(*) from mycte);

drop table foo;

drop table bar;

