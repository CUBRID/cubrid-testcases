--WITH INCREMENT FOR 
create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (109, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');

select * from test_class where bigint_col is NULL WITH INCREMENT FOR bigint_col ;
select * from test_class where bigint_col = 100 WITH INCREMENT FOR bigint_col ;
select * from test_class where bigint_col = 101 WITH INCREMENT FOR bigint_col ;

select * from test_class  order by 1;

drop class test_class;
