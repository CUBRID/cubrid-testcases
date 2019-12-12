create class test_class (bigint_col bigint);

insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);

select bigint_col + 1 from test_class;
select bigint_col - 1 from test_class;
select bigint_col * 2 from test_class;
select bigint_col + bigint_col from test_class;

drop class test_class;