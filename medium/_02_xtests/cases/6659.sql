autocommit off;
select 1 / NULL from class db_user;
create class foo (a int);
insert into foo values (1);
select a / NULL from foo;
rollback;
