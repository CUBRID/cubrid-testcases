create class test_class (bigint_col bigint);
alter class test_class rename attribute bigint_col as bigint_col1;
drop class test_class;