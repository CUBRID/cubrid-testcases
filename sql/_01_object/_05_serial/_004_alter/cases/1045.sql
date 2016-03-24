-- [er]create serial using ascending and start with and alter it using nominvalue 


create serial ser1
start with 10000000000000000000000000000000000000
INCREMENT BY 2;

alter serial ser1
NOMINVALUE ;

select * from db_serial WHERE name='ser1';

drop serial ser1;