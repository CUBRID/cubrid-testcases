-- [er]alter serial using MINVALUE more than 1



create serial ser1;
alter serial ser1
MINVALUE 1;

select * from db_serial WHERE name='ser1';

drop serial ser1;

create serial ser1;
alter serial ser1
MINVALUE  2;

select * from db_serial WHERE name='ser1';

drop serial ser1;