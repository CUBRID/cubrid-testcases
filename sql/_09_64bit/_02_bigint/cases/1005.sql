create class test_class (bigint_col bigint);
insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);
insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);

select * from test_class order by bigint_col;
select * from test_class order by bigint_col desc;
select * from test_class order by bigint_col asc;

drop class test_class;