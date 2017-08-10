--[er]test unique of constraint using NULL vaules with two attributes

create class test_class(
a integer ,
b integer,
unique(a,b));

insert into test_class(b) values(1);
insert into test_class(b) values(2);
insert into test_class(b) values(3);
insert into test_class(b) values(3);
select * from test_class;

drop class test_class;
