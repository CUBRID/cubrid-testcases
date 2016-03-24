--alter operation for db_serial by DBA

create class xoo ( a int);
create serial s1;

update db_serial set min_val  = 100 where name = 's1';
update db_serial set max_val  = 100 where name = 's1';
update db_serial set started  = 100 where name = 's1';

alter serial s1 start with 1100;
select * from db_serial where name  = 's1';
drop serial s1;
drop xoo;