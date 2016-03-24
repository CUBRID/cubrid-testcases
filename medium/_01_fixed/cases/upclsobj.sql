autocommit off;
create class foo (a object);
insert into foo default values;
update foo set a = class db_user;
insert into foo values (class foo);
select * from foo;
delete from foo where class foo = a;
select * from foo;
rollback;
