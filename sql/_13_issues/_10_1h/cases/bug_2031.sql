create table foo (a int, b int);
insert into foo values (1, 1);
insert into foo values (2, 2);
insert into foo values (3, 3);

select list (select a from foo order by a asc) from db_root;

select list (select a from foo order by a desc) from db_root;

drop table foo;

