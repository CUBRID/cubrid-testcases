-- create serial using INCREMENT BY which value is 2 and MINVALUE which value is 999999999999999999999999999999999998


create serial ser1
INCREMENT BY 2
MINVALUE 9999999999999999999999999999999999998
;

select * from db_serial WHERE name='ser1';

drop serial ser1;
