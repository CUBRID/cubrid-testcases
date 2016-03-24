autocommit off;
create class test_class(testNumber	integer,
			numval1		numeric(15,2));
insert into test_class values (1,999.66);    
select cast (numval1 as char varying(100)) from test_class;
rollback work;
rollback;
