-- create vclass using class attribute and retrieve info from db_vclass

create class test_class (serving_hours string);

create vclass v_test_class
class attribute (meal_type string default 'snack')
(serving_hours string)
as
select serving_hours from test_class;

select * from db_vclass
where vclass_name = 'v_test_class';
drop class test_class;
drop vclass v_test_class;