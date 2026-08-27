--Create a serial with default attribute and retrieve information from db_serail
create serial test_serial;

select CONCAT (LOWER (owner.name), '.', name) as unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial
where name = 'test_serial';

drop serial test_serial;
