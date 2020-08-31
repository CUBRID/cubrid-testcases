--Test db_attribute by creating class with default object attribute 
set system parameters 'create_table_reuseoid=no';

create class test_ob_class (col1 varchar(10),col2 date);
insert into test_ob_class values('nhnchina',to_date('20080427','yyyymmdd')) into :arg1;


create class test_class (col1 integer, col2 test_ob_class default :arg1);



select attr_name, class_name
from   db_attribute
where  class_name = 'test_class' order by 1,2;

drop class test_ob_class;
drop class test_class;


set system parameters 'create_table_reuseoid=yes';
