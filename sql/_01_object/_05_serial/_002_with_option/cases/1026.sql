-- create serial using MINVALUE  which value is 9999999999999999999999999999999999999


create serial ser1
MINVALUE  9999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;



create serial ser1
MINVALUE  12;

select * from db_serial WHERE name='ser1';

drop serial ser1;