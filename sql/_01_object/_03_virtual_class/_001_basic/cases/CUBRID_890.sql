-- bug fix for CUBRID 890


create class picture
(caption set string,
image string); 
insert INTO picture VALUES ({'s'},'s');

create vclass meal
class attribute (meal_type string shared 'a' unique)
(menu picture);

drop vclass meal;
drop class picture;

