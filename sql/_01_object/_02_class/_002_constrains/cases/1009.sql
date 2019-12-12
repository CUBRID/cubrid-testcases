--test unique of constraint using NULL vaules

create class test_class(
a integer ,
b integer,
unique(a));

insert into test_class(b) values(1);
insert into test_class(b) values(2);
insert into test_class(b) values(3);
select * from test_class;

drop class test_class;
