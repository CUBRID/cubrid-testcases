create class test_class (int_col int, bigint_col bigint default 99);

insert into test_class values(1, NULL);
insert into test_class values(2, 100);
insert into test_class(int_col) values(3);

select * from test_class order by 1;

drop class test_class;