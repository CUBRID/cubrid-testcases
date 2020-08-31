-- create vclass attribute using default and not null constraints
set system parameters 'create_table_reuseoid=no';

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create vclass meal
class attribute (meal_type string default 'a' not null)
(menu picture);
 
 select * FROM db_attribute WHere class_name='meal' order by 1,2,3,4,5;
 
 
 SELECT * FROM meal;
 
 
 DROP picture;
 
 DROP meal;

set system parameters 'create_table_reuseoid=yes';
