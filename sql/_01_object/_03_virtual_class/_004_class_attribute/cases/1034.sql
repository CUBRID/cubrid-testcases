-- create vclass attribute same name as instance attribute
set system parameters 'create_table_reuseoid=no';

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create vclass meal
class attribute (menu string)
(menu picture);
 
 select * FROM db_attribute WHere class_name='meal'  order by attr_type;
 
 
 SELECT * FROM meal;
 
 
 DROP picture;
 
 DROP meal;

set system parameters 'create_table_reuseoid=yes';
