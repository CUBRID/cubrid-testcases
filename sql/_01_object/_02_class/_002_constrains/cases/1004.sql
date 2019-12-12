--[er]test unique of constraint using duplicate value with two attributes 

create class test_class(
a integer,
b integer,
UNIQUE(a,b));

insert into test_class values(1, 2);
insert into test_class values(1, 3);
insert into test_class values(1, 2);

select * from test_class;

drop class test_class;
