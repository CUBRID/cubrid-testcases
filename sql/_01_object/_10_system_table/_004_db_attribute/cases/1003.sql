--Create class with DEFAULT attribute and retrieve attribute type from db_attribue
set system parameters 'create_table_reuseoid=no';

create class test_class(col1 integer);
insert into test_class values(999) into :arg1;

create class test_class2(col1 integer, col2 test_class SHARED :arg1);
insert into test_class2(col1) values (1);
select col1, col2.col1 from test_class2;


select * from db_attribute 
where  class_name = 'test_class2' and attr_type = 'INSTANCE';


drop class test_class;
drop class test_class2;

set system parameters 'create_table_reuseoid=yes';
