--+ holdcas on;
create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');

select power(bigint_col, -2) from test_class order by 1;

set system parameters 'compat_mode=mysql';
select to_char(power(bigint_col, -2),'9.9999999EEEE') from test_class order by 1;
set system parameters 'compat_mode=cubrid';

drop class test_class;
commit;
--+ holdcas off;
