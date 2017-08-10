create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (109, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');

select mod(bigint_col, 10), bigint_col from test_class order by 1,2;
select mod(bigint_col, -100), bigint_col from test_class order by 1,2;
select mod(bigint_col, 0), bigint_col from test_class order by 1,2;

drop class test_class;