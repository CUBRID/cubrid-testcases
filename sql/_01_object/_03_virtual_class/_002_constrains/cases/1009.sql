-- create view using default keyword on class attribute of data type 
create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string default 'snack')
(serving_hours string default 'a')
as
select serving_hours from snack;


DROP vsnack;
DROP snack;