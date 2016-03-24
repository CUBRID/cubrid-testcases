-- [er]create serial using INCREMENT BY  and  MAXVALUE wrong order


create serial ser1
MAXVALUE 222
INCREMENT BY -2;

select * from db_serial WHERE name='ser1';

drop serial ser1;
