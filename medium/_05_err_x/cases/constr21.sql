autocommit off;

create class foo (a char);
insert into foo(a) values('two?');
rollback work;
rollback;
