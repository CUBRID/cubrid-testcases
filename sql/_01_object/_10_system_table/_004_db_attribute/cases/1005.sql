--Test db_attribute's attribute domain_class_name
set system parameters 'create_table_reuseoid=no';

create class test_ob_class (col1 integer, col2 varchar(10));

insert into test_ob_class values(999, 'Dennis') into :arg1;
create class test_class (col1 integer, col2 test_ob_class);
insert into test_class values(111,arg1);


select attr_name, class_name, domain_class_name
from   db_attribute
where  class_name = 'test_class' order by 1,2;

drop class test_ob_class;

select attr_name, class_name, domain_class_name
from   db_attribute
where  class_name = 'test_class' order by 1,2;

drop class test_class;

set system parameters 'create_table_reuseoid=yes';
