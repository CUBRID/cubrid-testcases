autocommit off;
insert into foo(a) select 1 from db_user;
select * from foo;
rollback;
