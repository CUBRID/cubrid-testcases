-- [er]create serial using INCREMENT BY  and  MINVALUE wrong order


create serial ser1
MINVALUE 222
INCREMENT BY -2;

select * from db_serial WHERE name='ser1';

drop serial ser1;
