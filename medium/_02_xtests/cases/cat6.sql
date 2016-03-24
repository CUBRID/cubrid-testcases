autocommit off;
call login('dba', '') on class db_user;
create class foo06 (fa int, fb int, fc int);
create class bar061 under foo06 (ba1 int, bb1 int); 
create class bar062 under foo06 (ba2 int, bb2 int);
create class bar063 under foo06 (ba3 int, bb3 int);
create class cuu061 under bar061 (da1 int);
create class cuu062 under bar061, bar062 (da2 int);
select class_name 
from db_direct_super_class 
where super_class_name = 'foo06' 
order by class_name;
select super_class_name 
from db_direct_super_class 
where class_name = 'cuu062' 
order by super_class_name;
select attr_name, from_class_name 
from db_attribute 
where class_name = 'cuu062' 
order by attr_name, from_class_name;
drop class bar061, bar063;
select class_name 
from db_direct_super_class 
where super_class_name = 'foo06' 
order by class_name;
select attr_name, from_class_name 
from db_attribute 
where class_name = 'cuu062' 
order by attr_name, from_class_name;
rename class foo06 as new_foo06;
select super_class_name 
from db_direct_super_class 
where class_name = 'bar062' 
order by super_class_name;
select data_type, domain_class_name 
from db_attribute 
where class_name = 'bar062' and attr_name = 'bc' and attr_type = 'INSTANCE' 
order by data_type, domain_class_name;
rename class new_foo06 as foo06;
alter class bar062 add attribute fa int inherit fa of foo06 as fa_from_foo06;
select attr_name 
from db_attribute 
where class_name = 'bar062' 
order by attr_name;
drop class foo06;
drop class bar062;
drop class cuu061;
drop class cuu062;
select * 
from db_class 
where class_name = 'foo06' or class_name = 'bar062' or class_name = 'cuu061' or class_name = 'cuu062' 
order by class_name;
call login('dba', '') on class db_user;
rollback;
