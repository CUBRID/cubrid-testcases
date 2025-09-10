-- [er] create serial with nocycle and the next value is exceeds maxvalue

create serial ser1
MINVALUE 1
MAXVALUE 3
NOCYCLE;

SELECT ser1.next_value,ser1.next_value,ser1.next_value,ser1.next_value FROM db_root;

select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';





drop serial ser1;