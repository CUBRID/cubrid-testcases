-- [er] create serial using start with , INCREMENT BY which value is  -2 and  MAXVALUE which value is -999999999999999999999999999999999999


create serial ser1
start with 2
INCREMENT BY -2
MAXVALUE -999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;
