--+ holdcas on;
-- [er]create class attribute using  null and unique constraints
set system parameters 'create_table_reuseoid=no';

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create class meal
class attribute (meal_type string null unique)
(menu picture);
 
 select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment FROM db_attribute WHere class_name='meal';
 
 SELECT picture INTO a FROM picture where image='s';
 
 INSERT INTO meal VALUES (a);
 
 SELECT * FROM meal;
 
 
 DROP picture;
 
 DROP meal;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
