autocommit off;
create class foo(i int);
insert into foo values(1) into :p;
drop foo;
update object :p set i=2;
select * from foo;
rollback;
