--+ holdcas on;
drop table if exists foo;
drop table if exists goo;
create table foo(id int, parent int);
insert into foo values(0,-1);
insert into foo values(1,0);
insert into foo values(2,1);
create table goo(id int);
insert into goo values(0);
insert into goo values(2);
select foo.* from foo
start with parent=-1
connect by prior id = parent;
select foo.* from foo
where EXISTS (select 1 from goo where foo.id = goo.id)
start with foo.parent=-1
connect by prior foo.id = foo.parent;
drop table if exists foo;
drop table if exists goo;
--+ holdcas off;
