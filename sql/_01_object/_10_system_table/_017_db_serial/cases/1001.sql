--create serial and retrieve information from db_serial
create class test1 ( a int, b int, c int);
create unique index u_idx  on test1(a,b,c);
create serial a_serial increment by  1;
create serial b_serial increment by  2;
create serial c_serial increment by  3;
insert into test1 values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);
insert into test1 values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);
insert into test1 values ( a_serial.next_value, b_serial.next_value, c_serial.next_value);

select * from db_serial;
drop class test1;
drop serial a_serial;
drop serial b_serial;
drop serial c_serial;
