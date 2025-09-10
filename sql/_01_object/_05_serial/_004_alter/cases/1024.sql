-- alter serial using NOMAXVALUE on ascending serial


create serial ser1
INCREMENT BY 2;
alter serial ser1
NOMAXVALUE  ;

select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;