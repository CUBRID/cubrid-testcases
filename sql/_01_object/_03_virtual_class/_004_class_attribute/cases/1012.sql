-- create vclass attribute same name as instance attribute and same type

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create vclass meal
class attribute (menu string)
(menu string);
 
 select * FROM db_attribute WHere class_name='meal'  order by 1;
 
 SELECT * FROM meal;
 
 
 DROP picture;
 
 DROP meal;
