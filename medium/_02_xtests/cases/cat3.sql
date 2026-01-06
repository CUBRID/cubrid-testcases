autocommit off;
create class foo03 (a double, b string, c object, d set(foo03), e multiset(foo03), f sequence(foo03), h time, i timestamp, k date, l monetary, n numeric(20,3), o bit,  p bit varying, q char, r nchar, s nchar varying);
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment 
from db_attribute 
where class_name = 'foo03' 
order by attr_name, attr_type;
select * 
from db_attr_setdomain_elm 
where class_name = 'foo03' 
order by attr_name, attr_type;
drop class foo03;
rollback work;
rollback;
