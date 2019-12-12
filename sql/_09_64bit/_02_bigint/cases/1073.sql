--INCR
create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (109, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');

select INCR(bigint_col), bigint_col from test_class where bigint_col is NULL;
select INCR(bigint_col), bigint_col from test_class where bigint_col = 100;
select INCR(bigint_col), bigint_col from test_class where bigint_col = 101;

select * from test_class order by 1,2;

select INCR(bigint_col), bigint_col from test_class where bigint_col > 0 ;

drop class test_class;
