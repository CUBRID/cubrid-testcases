autocommit off;

create class foo (a char(4));
insert into foo(a) values('two?');
rollback work;
rollback;
