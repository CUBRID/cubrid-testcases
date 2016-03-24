-- [er] alter serial using start with which value is -999999999999999999999999999999999999


create serial ser1;
alter serial ser1
START WITH -999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;
