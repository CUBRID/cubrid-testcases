-- [er]create class attribute using not null constraints

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create class meal
class attribute (meal_type string not null)
(menu picture);
 
 select * FROM db_attribute WHere class_name='meal';
 
 SELECT picture INTO a FROM picture where image='s';
 
 INSERT INTO meal VALUES (a);
 
 SELECT * FROM meal;
 
 
 DROP picture;
 
 DROP meal;