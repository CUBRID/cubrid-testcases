autocommit off;
create class test_class ;
alter class test_class add attribute 
	testNumber	integer,
	varbitval1	bit varying(100),
	bitval1		bit (100);
insert into test_class 
values (1, B'00000010', B'02000000' );
insert into test_class 
values (1, X'ggg000010', B'01000000' );
rollback;
