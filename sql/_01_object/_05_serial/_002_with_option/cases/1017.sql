-- [er]create serial using INCREMENT BY which value is -10000000000000000000000000000000000000


create serial ser1
INCREMENT BY -10000000000000000000000000000000000000;

select * from db_serial WHERE name='ser1';

drop serial ser1;