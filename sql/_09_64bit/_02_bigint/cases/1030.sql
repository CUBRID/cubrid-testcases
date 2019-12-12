create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (-2147483648, 'minus');
insert into test_class(bigint_col, char_col) values (-2147483648, 'minus');
insert into test_class(bigint_col, char_col) values (2147483647, 'plus');
insert into test_class(bigint_col, char_col) values (2147483647, 'plus');

select min(bigint_col) from test_class;
select max(bigint_col) from test_class;

delete from test_class where bigint_col = -9223372036854775808;
delete from test_class where bigint_col = 9223372036854775807;
select avg(bigint_col) from test_class;
select sum(bigint_col) from test_class;

drop class test_class;