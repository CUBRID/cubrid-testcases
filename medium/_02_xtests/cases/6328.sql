autocommit off;
/*
   BIT_LENGTH() function shows inconsistency..
*/
 create class foo(f1 varchar(8));
 insert into foo values(NULL);
 insert into foo values('ahc');
 insert into foo values(NULL);
 select octet_length(f1) from foo;
rollback;
