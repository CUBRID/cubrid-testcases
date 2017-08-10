create class test_class (bigint_col bigint, char_col char(20), UNIQUE(bigint_col));

insert into test_class values(1, 'a');
insert into test_class values(2, 'b');
insert into test_class values(3, 'a');
insert into test_class values(3, 'c');

select * from test_class order by 1,2;

drop class test_class;
