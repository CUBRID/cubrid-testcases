-- [er]create serial using NOMINVALUE ascending and start with 


create serial ser1
start with 10000000000000000000000000000000000000
INCREMENT BY 2
NOMINVALUE ;

select * from db_serial WHERE name='ser1';

drop serial ser1;