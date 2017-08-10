create class test_class (bigint_col bigint);

insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);
insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);

create index idx_bigint_col on test_class(bigint_col);

select * from test_class order by 1 desc;

drop class test_class;