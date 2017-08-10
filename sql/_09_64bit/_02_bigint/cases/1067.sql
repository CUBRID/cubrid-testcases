create class test_class (int_col int, bigint_col bigint default 99);

insert into test_class(int_col) values(3);

alter class test_class modify bigint_col bigint default 999;

insert into test_class(int_col) values(4);

select * from test_class order by int_col asc;

drop class test_class;