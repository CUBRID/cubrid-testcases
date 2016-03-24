-- create serial using INCREMENT BY which value is -999999999999999999999999999999999999


create serial ser1
INCREMENT BY -999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;
create serial ser1
INCREMENT BY -12;

select * from db_serial WHERE name='ser1';

drop serial ser1;