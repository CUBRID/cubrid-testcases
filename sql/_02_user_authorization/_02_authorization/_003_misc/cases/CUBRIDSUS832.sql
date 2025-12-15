--alter operation for _db_serial by DBA

create class xoo ( a int);
create serial s1;

update _db_serial set min_val  = 100 where name = 's1';
update _db_serial set max_val  = 100 where name = 's1';
update _db_serial set started  = 100 where name = 's1';

alter serial s1 start with 1100;
select unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial where name  = 's1';
drop serial s1;
drop xoo;