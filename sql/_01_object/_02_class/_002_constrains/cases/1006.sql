--[er]test unique of constraint using duplicate values with one attribute

create class test_class(
a integer,
UNIQUE(a));

insert into test_class values(1);
insert into test_class values(2);
insert into test_class values(2);

select * from test_class;

drop class test_class;
