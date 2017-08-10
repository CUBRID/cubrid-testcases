-- create vclass attribute same name as instance attribute

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create vclass meal
class attribute (menu string)
(menu picture);
 
 select * FROM db_attribute WHere class_name='meal'  order by 1,2,3;
 
 
 SELECT * FROM meal;
 
 
 DROP picture;
 
 DROP meal;
