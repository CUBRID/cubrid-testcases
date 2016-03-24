-- [er] create serial with nocycle and the next value is exceeds maxvalue

create serial ser1
MINVALUE 1
MAXVALUE 3
NOCYCLE;

SELECT ser1.next_value,ser1.next_value,ser1.next_value,ser1.next_value FROM db_root;

select * from db_serial WHERE name='ser1';





drop serial ser1;