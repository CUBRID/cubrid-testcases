create class test_class (bigint_col bigint);
create index idx_bigint_col on test_class(bigint_col);
drop index idx_bigint_col on test_class;
drop class test_class;
