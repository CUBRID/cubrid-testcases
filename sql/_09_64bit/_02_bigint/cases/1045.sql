create class test_class (bigint_col bigint);

insert into test_class(bigint_col) values (-9223372036854775800.43); 
insert into test_class(bigint_col) values (-9223372036854775800.63); 
insert into test_class(bigint_col) values (9223372036854775800.43); 
insert into test_class(bigint_col) values (9223372036854775800.63); 

select * from test_class order by 1;

drop class test_class;
