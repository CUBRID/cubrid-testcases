-- [er]create serial using START WITH  and  MAXVALUE wrong order


create serial ser1
MAXVALUE 222
START WITH -2;

select * from db_serial WHERE name='ser1';

drop serial ser1;
