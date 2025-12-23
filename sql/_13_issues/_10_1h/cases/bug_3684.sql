create class aoo ( a int, b blob, c clob);
insert into aoo values(1, bit_to_blob(X'1122aabb'), char_to_clob('asselect'));
create class boo as select * from aoo;

select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name='boo' order by 1;

delete from aoo;
delete from boo;
drop aoo;
drop boo;
