-- [er]create serial using INCREMENT BY which value is  2 and alter it using  MINVALUE which value is -999999999999999999999999999999999998


create serial ser1
INCREMENT BY 2;

alter serial ser1
MINVALUE -999999999999999999999999999999999998;

select * from db_serial WHERE name='ser1';

drop serial ser1;
