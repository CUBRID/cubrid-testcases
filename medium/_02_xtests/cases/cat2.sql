autocommit off;
call login('dba', '') on class db_user;
create class foo02;
create class bar02(ba int not null, bb float default 10.3, bc char(10), bd numeric(7,3), be foo02);
select * 
from db_attribute 
where class_name = 'bar02' 
order by attr_name, attr_type;
alter class bar02 add attribute bg set(int, char(10), foo02);
select * 
from db_attr_setdomain_elm 
where class_name = 'bar02' and attr_name = 'bg' and attr_type = 'INSTANCE' 
order by data_type;
alter class foo02 add attribute fa int shared NULL, fb char(10) shared NULL;
alter class foo02 add class attribute fa int, fb char(10);
select attr_name, attr_type, data_type 
from db_attribute 
where class_name = 'foo02' 
order by attr_name, attr_type, data_type; 
create class cuu02 (ca cuu02);
select domain_class_name 
from db_attribute 
where class_name = 'cuu02' and attr_name = 'ca' 
order by domain_class_name;
alter class cuu02 add attribute cb set(cuu02);
select domain_class_name 
from db_attr_setdomain_elm 
where class_name = 'cuu02' and attr_name = 'cb' 
order by domain_class_name;
alter class cuu02 rename ca as new_ca;
select * 
from db_attribute 
where class_name = 'cuu02' and attr_name = 'new_ca' 
order by attr_type;
alter class cuu02 rename new_ca as ca;
alter class cuu02 add attribute cc varchar(20), cd float;
alter class cuu02 drop attribute cb;
alter class cuu02 add attribute ce int;
alter class cuu02 add attribute cf numeric(10,2);
alter class cuu02 drop attribute cd, cf;
select * 
from db_attribute 
where class_name = 'cuu02' 
order by attr_name, attr_type;
alter class cuu02 modify cc varchar(20) default 'i am default value';
select default_value 
from db_attribute 
where class_name = 'cuu02' and attr_name = 'cc' 
order by default_value;
alter class cuu02 drop attribute cc;
select attr_name, def_order 
from db_attribute 
where class_name = 'cuu02' 
order by attr_name, def_order;
drop class foo02;
drop class bar02;
drop class cuu02;
call login('dba', '') on class db_user;
rollback;
