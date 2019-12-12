-- [er]create view using UNIQUE keyword on class attribute of data type 

create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string default 'snack')
(serving_hours string UNIQUE)
as
select serving_hours from snack;


DROP vsnack;
DROP snack;