-- [er]create vclass using Constraints  DEFAULT 2147483648

create vclass t1 (
c1 int  DEFAULT 2147483648 
);
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment FROM db_attribute  WHERE class_name='t1';

drop t1;