create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (109, 'plus');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (109, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');

SELECT bigint_col, CASE WHEN bigint_col = 9223372036854775807 THEN 'MAX'
 WHEN bigint_col = 9223372036854775808 THEN 'MIN'
 WHEN bigint_col = 0 THEN 'ZERO'
 ELSE 'OTHER'
 END
FROM test_class order by 1;

drop class test_class;