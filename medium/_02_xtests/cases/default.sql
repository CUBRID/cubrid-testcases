autocommit off;
create class foo (a int, b int default 1);
insert into foo(a) select 1 from db_user;
select * from foo;
rollback;
