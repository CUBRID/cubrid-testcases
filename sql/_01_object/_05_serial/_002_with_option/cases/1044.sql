-- create serial using NOMINVALUE descending 


create serial ser1
INCREMENT BY -2
NOMINVALUE ;

select * from _db_serial WHERE name='ser1';

drop serial ser1;