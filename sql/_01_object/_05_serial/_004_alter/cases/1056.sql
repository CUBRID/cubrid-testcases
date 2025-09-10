-- create serial using START WITH which value is  -2 and alter it using MAXVALUE which value is -999999999999999999999999999999999998


create serial ser1
INCREMENT BY -2;
alter serial ser1
MAXVALUE -999999999999999999999999999999999998;

select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial WHERE name='ser1';

drop serial ser1;
