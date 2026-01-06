--Create class with not null attribute and retrieve info from db_attribute 

create class xoo ( id int not null, name string );

select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute where class_name = 'xoo' order by 1;

drop xoo;
