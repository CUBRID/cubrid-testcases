-- [er]create serial using start with which value is 10000000000000000000000000000000000000


create serial ser1
START WITH 10000000000000000000000000000000000000;

select * from db_serial WHERE name='ser1';

drop serial ser1;