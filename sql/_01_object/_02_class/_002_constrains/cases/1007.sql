--[er]test unique of constraint using default keyword

create class test_class(
a integer ,
b integer default 888,
unique(b));

insert into test_class(a) values(1);
insert into test_class(a) values(2);
select * from test_class;

drop class test_class;