-- [er]create vclass using  DEFAULT and not null keyword and shared



create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string DEFAULT 'a' NOT NULL)
(serving_hours string SHARED 'a')
as
select serving_hours from snack;

drop vsnack;
drop snack;