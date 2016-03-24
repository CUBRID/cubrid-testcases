
--+ holdcas on;

drop table if exists foo;
create table foo (id int);
insert into foo values (null),(null),(1),(2),(3),(4);
select id from (select * from foo order by 1) foo order by id;
select id from (select * from foo order by 1) foo order by id nulls first;
select id from (select * from foo order by 1) foo order by id nulls last;
select id from (select * from foo order by 1) foo order by id desc;
select id from (select * from foo order by 1) foo order by id desc nulls last;
select id from (select * from foo order by 1) foo order by id desc nulls first;
drop table if exists foo;

--+ holdcas off;
commit;
