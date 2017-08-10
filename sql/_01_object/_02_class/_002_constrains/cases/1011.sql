--test PK of constraint using int data type

create class test_class(
a integer primary key);

insert into test_class values(1);
insert into test_class values(2);
insert into test_class values(3);

select * from test_class;

drop class test_class;