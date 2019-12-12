--to_char()
create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (-2147483648, 'minus');
insert into test_class(bigint_col, char_col) values (2147483647, 'plus');
insert into test_class(bigint_col, char_col) values (null, 'null');

select bigint_col, to_char(bigint_col, '999999999999EEEE') from test_class;
select bigint_col, to_char(bigint_col, '000000000000EEEE') from test_class;
select bigint_col, to_char(bigint_col, 'A 999') from test_class;
select bigint_col, to_char(bigint_col, 'CUBRID') from test_class;
select bigint_col, to_char(bigint_col, '999999999.9999999.99999999.999') from test_class;
select bigint_col, to_char(bigint_col, '000000000.0000000.99999999.999') from test_class;
select bigint_col, to_char(bigint_col, '999,999,999,999,888,000,000.999') from test_class;
select bigint_col, to_char(bigint_col, '+999999999999') from test_class;
select bigint_col, to_char(bigint_col, '-999999999999') from test_class;

drop class test_class;