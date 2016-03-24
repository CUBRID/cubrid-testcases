-- alter serial using NOMAXVALUE on ascending serial


create serial ser1
INCREMENT BY 2;
alter serial ser1
NOMAXVALUE  ;

select * from db_serial WHERE name='ser1';

drop serial ser1;