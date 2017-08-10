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

select bigint_col, to_char(bigint_col) from test_class order by 1;
select bigint_col, to_char(bigint_col) from test_class order by 1;
select bigint_col, to_char(bigint_col, '999999999999999999999999') from test_class order by 1;
select bigint_col, to_char(bigint_col, '000000000000000000000000') from test_class order by 1;
select bigint_col, to_char(bigint_col, 'S999999999999999999999999') from test_class order by 1;
select bigint_col, to_char(bigint_col, 'S000000000000000000000000') from test_class order by 1;
select bigint_col, to_char(bigint_col, 'C999999999999999999999999') from test_class order by 1;
select bigint_col, to_char(bigint_col, 'C000000000000000000000000') from test_class order by 1;
select bigint_col, to_char(bigint_col, '99.99EEEE') from test_class order by 1;
select bigint_col, to_char(bigint_col, '99.00EEEE') from test_class order by 1;
select bigint_col, to_char(bigint_col, '999,999,999,999,999,999,999,999') from test_class order by 1;
select bigint_col, to_char(bigint_col, '000,000,000,000,000,000,000,000') from test_class order by 1;
select bigint_col, to_char(bigint_col, '999999999999999999999999.999') from test_class order by 1;
select bigint_col, to_char(bigint_col, '000000000000000000000000.000') from test_class order by 1;
select bigint_col, to_char(bigint_col, '999,999,999,999,999,999,999.999') from test_class order by 1;
select bigint_col, to_char(bigint_col, '000,000,000,000,000,000,000.000') from test_class order by 1;
select bigint_col, to_char(bigint_col, '999,999,999,999,999,000,000.999') from test_class order by 1;
select bigint_col, to_char(bigint_col, '000,000,000,000,000,999,999.000') from test_class order by 1;

drop class test_class;