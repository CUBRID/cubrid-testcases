--[er]test PK of constraint using duplicate value

create class test_class(
a integer primary key);

insert into test_class(a) values(1);
insert into test_class(a) values(2);
insert into test_class(a) values(3);
insert into test_class(a) values(3);

select * from test_class order by 1;

drop class test_class;
