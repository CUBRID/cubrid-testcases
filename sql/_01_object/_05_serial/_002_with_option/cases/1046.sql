-- [er]create serial using NOMINVALUE descending  and start with 


create serial ser1
START WITH -1000000000000000000000000000000000000
INCREMENT BY -2
NOMINVALUE ;

select * from db_serial WHERE name='ser1';

drop serial ser1;