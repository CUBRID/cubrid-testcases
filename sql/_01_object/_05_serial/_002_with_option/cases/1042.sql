-- create serial using NOMINVALUE 


create serial ser1
NOMINVALUE ;

select * from db_serial WHERE name='ser1';

drop serial ser1;