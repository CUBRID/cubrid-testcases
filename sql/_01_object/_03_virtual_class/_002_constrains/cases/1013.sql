-- create vclass using shared and not null keyword 


create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string SHARED 'snack' NOT NULL)
(serving_hours string)
as
select serving_hours from snack;

drop vsnack;
drop snack;