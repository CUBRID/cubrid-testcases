--create serial and retrieve information from _db_serial
create class test1 ( a int, b int, c int);
create unique index u_idx  on test1(a,b,c);
create serial a_serial increment by  1;
create serial b_serial increment by  2;
create serial c_serial increment by  3;
insert into test1 values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);
insert into test1 values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);
insert into test1 values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);

select CONCAT (LOWER (owner.name), '.', name) as unique_name, name, owner, current_val, increment_val, max_val, min_val, start_val, cyclic, started, class_name, attr_name, cached_num, comment from _db_serial;
drop class test1;
drop serial a_serial;
drop serial b_serial;
drop serial c_serial;
