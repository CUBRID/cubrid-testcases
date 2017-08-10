create class test_class (bigint_col bigint);

insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);

select bigint_col + 1 from test_class order by 1;
select bigint_col - 1 from test_class order by 1;
select bigint_col / 2 from test_class order by 1;
select bigint_col * 2 from test_class order by 1;

drop class test_class;