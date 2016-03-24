autocommit off;
create class foo(x int);
update foo set x = 1;
select * from foo;
rollback;
