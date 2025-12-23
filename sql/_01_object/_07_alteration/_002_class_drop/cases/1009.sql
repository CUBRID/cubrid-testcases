-- drop class attribute

CREATE CLASS ddl_0001 (a1 int,a2 int);

insert into ddl_0001 values (1,2);

ALTER ddl_0001 add CLASS ATTRIBUTE qwe STRING;


ALTER ddl_0001 drop CLASS qwe;

SELECT attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment FROM db_attribute WHERE  class_name = 'ddl_0001' order by 1,2;

select * from ddl_0001;

drop ddl_0001;
