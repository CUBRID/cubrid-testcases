create class test_class (bigint_col bigint, smallint_col smallint, int_col int, numeric_col numeric,float_col float, double_col double);
insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (-9223372036854775808, 1, 2, 3.3, 4.4, 5.5);
insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (9223372036854775807, 1, 2, 3.3, 4.4, 5.5);

insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (88, 88, 88, 88, 88, 88);
delete from test_class where bigint_col = smallint_col;
insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (88, 88, 88, 88, 88, 88);
delete from test_class where bigint_col = int_col;
insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (88, 88, 88, 88, 88, 88);
delete from test_class where bigint_col = numeric_col;
insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (88, 88, 88, 88, 88, 88);
delete from test_class where bigint_col = float_col;
insert into test_class(bigint_col, smallint_col, int_col, numeric_col, float_col, double_col) values (88, 88, 88, 88, 88, 88);
delete from test_class where bigint_col = double_col;

drop class test_class;