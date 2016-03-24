-- alter  serial using NOMAXVALUE  


create serial ser1;
alter serial ser1
NOMAXVALUE  ;

select * from db_serial WHERE name='ser1';

drop serial ser1;