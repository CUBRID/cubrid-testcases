-- create serial and alter it using NOMINVALUE ascending 


create serial ser1
INCREMENT BY 2;

alter serial ser1
NOMINVALUE ;

select * from db_serial WHERE name='ser1';

drop serial ser1;