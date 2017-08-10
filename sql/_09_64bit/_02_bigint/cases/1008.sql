create class test_class (bigint_col bigint);

insert into test_class(bigint_col) values (-9223372036854775809);
insert into test_class(bigint_col) values (9223372036854775808);
insert into test_class(bigint_col) values ('aaaa');

select * from test_class order by 1;

drop class test_class;