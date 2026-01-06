autocommit off;
create view v_x_int;
alter view v_x_int add attribute x int;
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'v_x_int';
drop view v_x_int;
rollback;
