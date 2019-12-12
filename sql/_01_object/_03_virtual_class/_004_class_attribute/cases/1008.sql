-- create vclass using class attribute 
create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string default 'snack')
(serving_hours string)
as
select serving_hours from snack;

drop vsnack;
drop snack;