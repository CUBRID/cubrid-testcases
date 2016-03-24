-- [er]create serial using start with which value is 2 and alter it using increment by which value is 999999999999999999999999999999999999


create serial ser1
START WITH 2;
alter serial ser1
INCREMENT BY 9999999999999999999999999999999999999
;

select * from db_serial WHERE name='ser1';

drop serial ser1;
