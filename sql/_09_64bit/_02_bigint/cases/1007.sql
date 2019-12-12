create class test_class (bigint_col bigint);
insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);
insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);

delete from test_class where bigint_col = 9223372036854775807;
delete from test_class where bigint_col > 100;
delete from test_class where bigint_col < 100;
delete from test_class where bigint_col = 100;
delete from test_class where bigint_col >= 100;
delete from test_class where bigint_col <= 100;

drop class test_class;