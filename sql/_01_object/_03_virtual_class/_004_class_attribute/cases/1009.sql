-- [er]create vclass using class attribute using different class name

create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string default 'snack')
(serving_hours string)
as
select serving_hours from snack1;

drop vsnack;
drop snack;