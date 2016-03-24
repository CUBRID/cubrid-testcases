-- create serial using start with , INCREMENT BY which value is  -2 and alter it using MINVALUE which value is -999999999999999999999999999999999999


create serial ser1
start with 2
INCREMENT BY -2;

alter serial ser1
MINVALUE -999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;
