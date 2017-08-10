-- create vclass using  shared and not null keyword and default


create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string SHARED 'a' NOT NULL)
(serving_hours string DEFAULT 'a')
as
select serving_hours from snack;

drop vsnack;
drop snack;