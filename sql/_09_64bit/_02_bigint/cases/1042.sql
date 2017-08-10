create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');

select VARIANCE(bigint_col) from test_class;
select VARIANCE(DISTINCT bigint_col) from test_class;
select VARIANCE(UNIQUE bigint_col) from test_class;
select VARIANCE(ALL bigint_col) from test_class;

drop class test_class;
