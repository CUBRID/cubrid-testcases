-- create serial using NOMINVALUE ascending 


create serial ser1
INCREMENT BY 2
NOMINVALUE ;

select * from db_serial WHERE name='ser1';

drop serial ser1;