-- [er]create class attribute using default and not null constraints

create class picture
(caption set string,
 image string);
 
 insert INTO picture VALUES ({'s'},'s');
 
 create class meal
class attribute (meal_type string not null default 'a' )
(menu picture);
 
 select * FROM db_attribute WHere class_name='meal' order by 1;
 
 SELECT picture INTO a FROM picture where image='s' order by 1;
 
 INSERT INTO meal VALUES (a);
 
 SELECT * FROM meal order by 1;
 
 
 DROP picture;
 
 DROP meal;