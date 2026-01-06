--Create class with DEFAULT attribute and retrieve attribute type from db_attribue
set system parameters 'create_table_reuseoid=no';

create class test_class(col1 integer);
insert into test_class values(999) into :arg1;

create class test_class2(col1 integer, col2 test_class SHARED :arg1);
insert into test_class2(col1) values (1);
select col1, col2.col1 from test_class2;


select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute 
where  class_name = 'test_class2' and attr_type = 'INSTANCE';


drop class test_class;
drop class test_class2;

set system parameters 'create_table_reuseoid=yes';
