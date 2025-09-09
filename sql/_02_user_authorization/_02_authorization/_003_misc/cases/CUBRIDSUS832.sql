--alter operation for _db_serial by DBA

create class xoo ( a int);
create serial s1;

update _db_serial set min_val  = 100 where name = 's1';
update _db_serial set max_val  = 100 where name = 's1';
update _db_serial set started  = 100 where name = 's1';

alter serial s1 start with 1100;
select * from _db_serial where name  = 's1';
drop serial s1;
drop xoo;