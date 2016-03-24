-- [er]create serial using START WITH  and  MINVALUE wrong order


create serial ser1
MINVALUE 222
START WITH -2;

select * from db_serial WHERE name='ser1';

drop serial ser1;
