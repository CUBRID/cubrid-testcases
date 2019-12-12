create class test_class (bigint_col bigint);

create index idx_bigint_col on test_class(bigint_col);

insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);
insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);

select * from test_class where bigint_col in (-9223372036854775808, 9223372036854775807)  order by 1 ;
select * from test_class where bigint_col not in (-9223372036854775808, 9223372036854775807) order by 1; 

drop class test_class;