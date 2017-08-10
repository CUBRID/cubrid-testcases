create class test_class (int_col int, bigint_col bigint primary key);

insert into test_class(int_col) values(3);

alter class test_class modify bigint_col bigint default 999;

insert into test_class(int_col) values(4);
insert into test_class(int_col) values(4);
insert into test_class(int_col, bigint_col) values(5, 11);
insert into test_class(int_col, bigint_col) values(5, 12);
insert into test_class(int_col, bigint_col) values(5, 13);

select * from test_class order by 1,2;

drop class test_class;
