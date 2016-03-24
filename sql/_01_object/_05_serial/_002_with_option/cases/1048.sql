-- create serial using MAXVALUE  which value is 9999999999999999999999999999999999999


create serial ser1
MAXVALUE  9999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;



create serial ser1
MAXVALUE  12;

select * from db_serial WHERE name='ser1';

drop serial ser1;