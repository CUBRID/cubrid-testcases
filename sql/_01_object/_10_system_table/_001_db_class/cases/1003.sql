--Test db_class using create virtual class and retrieve relative information


--Create test class
create class test_class(col1 integer, col2 varchar(10), col3 date);

insert into test_class values(999, 'nhncorp', sysdate);
insert into test_class values(999, 'nhncorp', sysdate);

--Create virtual class base on test_class
create vclass test_vclass(col1, col3)
as 
select col1, col2 from test_class;

select * from db_class 
where  class_type = 'VCLASS';


drop vclass test_vclass;
drop class test_class;