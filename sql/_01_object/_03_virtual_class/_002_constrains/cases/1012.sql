-- create vclass using shared keyword

create CLASS brunch (serving_hours string);

create vclass vbrunch
(served_buffet_style string shared 'no',
 serving_hours string)
as
select NA, serving_hours from brunch;

drop brunch;
DROP vbrunch;