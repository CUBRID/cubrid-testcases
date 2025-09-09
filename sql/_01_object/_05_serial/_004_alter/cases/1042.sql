-- alter serial using NOMINVALUE 


create serial ser1;

alter serial ser1
NOMINVALUE ;

select * from _db_serial WHERE name='ser1';

drop serial ser1;