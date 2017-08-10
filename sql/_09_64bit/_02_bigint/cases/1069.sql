create class test_class (bigint_col bigint AUTO_INCREMENT PRIMARY KEY, char_col char(20));

insert into test_class(char_col) values('a');
insert into test_class(char_col) values('b');
insert into test_class(char_col) values('c');
insert into test_class(char_col) values('d');

select * from test_class order by 1,2;

drop class test_class;
