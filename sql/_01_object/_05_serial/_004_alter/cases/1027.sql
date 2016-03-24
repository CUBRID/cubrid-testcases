-- alter serial using MINVALUE less than 1


create serial ser1;
alter serial ser1
MINVALUE  -999999999999999999999999999999999999;

select * from db_serial WHERE name='ser1';

drop serial ser1;

create serial ser1;
alter serial ser1
MINVALUE  0;

select * from db_serial WHERE name='ser1';

drop serial ser1;