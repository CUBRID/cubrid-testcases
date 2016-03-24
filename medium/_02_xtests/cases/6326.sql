autocommit off;
/*
 BIT_LENGTH() failed to return NULL when argument is NULL.
*/
 create class foo(f1 int, f2 bit(3));
 insert into foo(f1) values(1);
 select * from foo;
 select bit_length(f2) from foo;
rollback;
