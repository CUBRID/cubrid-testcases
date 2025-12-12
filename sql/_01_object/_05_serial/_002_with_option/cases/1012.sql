-- create serial using start with which value is -999999999999999999999999999999999999


create serial ser1
START WITH -999999999999999999999999999999999999;

select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;

create serial ser1
START WITH -12;

select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;