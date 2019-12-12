--Test db_vclass using create virtual class and retrieve relative information
--Create test class
create class test_class(col1 integer, col2 varchar(10), col3 date);

insert into test_class values(999, 'nhncorp', '2001-05-05');
insert into test_class values(999, 'nhncorp', '2001-05-05');

--Create virtual class base on test_class
create vclass test_vclass(col1, col3)
as 
select col1, col2 from test_class;

select * from db_vclass 
where  vclass_name = 'test_vclass';


drop vclass test_vclass;
drop class test_class;