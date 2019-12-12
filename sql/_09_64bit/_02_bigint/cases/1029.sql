create class test_class (bigint_col bigint, char_col char(10));

insert into test_class(bigint_col, char_col) values (100, 'plus');

select to_char(power(bigint_col, 2),'9.9999999EEEE'), bigint_col from test_class;
select to_char(power(bigint_col, -2),'9.9999999EEEE'), bigint_col from test_class;
select to_char(power(bigint_col * 1.0, 2.1),'9.9999999EEEE'), bigint_col from test_class;
select to_char(power(bigint_col * 1.0, -2.1),'9.9999999EEEE'), bigint_col from test_class;
select to_char(power(bigint_col, 2.1),'9.9999999EEEE'), bigint_col from test_class;
select to_char(power(bigint_col, 3.1),'9.9999999EEEE'), bigint_col from test_class;

drop class test_class;
