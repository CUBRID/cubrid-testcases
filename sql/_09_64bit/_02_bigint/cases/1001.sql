create class test_class (bigint_col bigint);
alter class test_class add attribute bigint_col1 bigint, bigint_col2 bigint;
alter class test_class drop attribute bigint_col1, bigint_col2;
drop class test_class;