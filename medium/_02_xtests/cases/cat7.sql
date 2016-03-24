autocommit off;
create class foo07 (a int, b varchar(10));
create class s_foo07 (a int);
create class s_bar07 (c int);
alter class foo07 add superclass s_foo07, s_bar07;
select attr_name, from_class_name 
from db_attribute 
where class_name = 'foo07' 
order by attr_name, from_class_name;
alter class foo07 drop attribute a;
select attr_name, from_class_name 
from db_attribute 
where class_name = 'foo07' 
order by attr_name, from_class_name;
alter class foo07 add attribute c int inherit c of s_bar07 as c_from_s_bar07;
alter class foo07 drop attribute c inherit c of s_bar07 as c;
select attr_name, from_class_name 
from db_attribute 
where class_name = 'foo07' 
order by attr_name, from_class_name;
alter class foo07 drop superclass s_foo07, s_bar07;
select * 
from db_attribute 
where class_name = 'foo07' 
order by attr_name, attr_type;
drop class foo07;
drop class s_foo07;
drop class s_bar07;
rollback work;
rollback;
