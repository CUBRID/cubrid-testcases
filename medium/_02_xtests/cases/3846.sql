autocommit off;
 create class foo_0 (a int, foo_0_ref2 foo_0);
 create vclass foo(a1 foo_0) 
	as select foo_0_ref2 from foo_0 group by foo_0_ref2;
 insert into foo_0 values (0, NULL) into :p1;
 insert into foo_0 values (1, :p1);
 select * from foo;
rollback;
