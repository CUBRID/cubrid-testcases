-- [er]create serial using NOMAXVALUE  descending  and start with 


create serial ser1
START WITH -1000000000000000000000000000000000000
INCREMENT BY -2
NOMAXVALUE  ;

select CONCAT (LOWER (owner.name), '.', name) as unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;