-- create serial using NOMAXVALUE  ascending 


create serial ser1
INCREMENT BY 2
NOMAXVALUE  ;

select * from db_serial WHERE name='ser1';

drop serial ser1;