-- [er]alter serial using INCREMENT BY which value is -10000000000000000000000000000000000000


create serial ser1;
alter serial ser1
INCREMENT BY -10000000000000000000000000000000000000;

select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;