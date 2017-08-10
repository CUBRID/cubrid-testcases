-- [er] create view using not null keyword on class attribute of data type 
create CLASS snack (serving_hours string);

create vclass vsnack
class attribute (meal_type string default 'snack')
(serving_hours string not NULL)
as
select serving_hours from snack;


DROP vsnack;
DROP snack;