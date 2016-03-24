-- [er]create serial using NOMAXVALUE  ascending and start with 


create serial ser1
start with 10000000000000000000000000000000000000
INCREMENT BY 2
NOMAXVALUE  ;

select * from db_serial WHERE name='ser1';

drop serial ser1;