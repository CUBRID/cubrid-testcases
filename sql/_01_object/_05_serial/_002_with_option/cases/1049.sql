-- [er]create serial using MAXVALUE  which value is -999999999999999999999999999999999999


create serial ser1
MAXVALUE  -999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;
