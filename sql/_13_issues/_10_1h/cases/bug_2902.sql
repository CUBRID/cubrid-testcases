create table foo(
id int primary key,
d double,
vc varchar(128)
);
select * from db_attribute where class_name = 'foo' order by attr_name;

alter table foo rename attribute vc as vch, rename attribute d as d2;
select * from db_attribute where class_name = 'foo' order by attr_name;

alter table foo add attribute (f float), rename attribute f as flt;
select * from db_attribute where class_name = 'foo' order by attr_name;

alter table foo rename attribute d2 as dd, rename attribute dd as dbl;
select * from db_attribute where class_name = 'foo' order by attr_name;

drop table foo;
