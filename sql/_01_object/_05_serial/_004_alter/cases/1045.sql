-- [er]create serial using ascending and start with and alter it using nominvalue 


create serial ser1
start with 10000000000000000000000000000000000000
INCREMENT BY 2;

alter serial ser1
NOMINVALUE ;

select CONCAT (LOWER (owner.name), '.', name) as unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;