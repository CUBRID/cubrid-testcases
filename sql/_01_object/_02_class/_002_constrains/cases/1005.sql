--test unique of constraint using one integer data type attribute

create class test_class(
a integer,
UNIQUE(a));

insert into test_class values(1);
insert into test_class values(2);

select * from test_class;

drop class test_class;