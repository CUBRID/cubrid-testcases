create class test_class (bigint_col bigint);

create index idx_bigint_col on test_class(bigint_col);

insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);
insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);
insert into test_class(bigint_col) values (NULL);
insert into test_class(bigint_col) values (NULL);

select * from test_class where bigint_col = NULL;
select * from test_class where bigint_col <> NULL;
select * from test_class where bigint_col is NULL;
select * from test_class where bigint_col is not NULL order by 1;

drop class test_class;