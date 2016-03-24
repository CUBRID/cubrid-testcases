autocommit off;
call login('dba', '') on class db_user;
create class foo04;
alter class foo04 add method m_fa(int, varchar(10)) foo04;
select * 
from db_meth_arg 
where class_name = 'foo04' and meth_name = 'm_fa' and meth_type = 'INSTANCE' 
order by index_of;
alter class foo04 change method m_fa(int, varchar(10)) set(int);
select data_type, prec, scale, code_set, domain_class_name 
from db_meth_arg 
where class_name = 'foo04' and meth_name = 'm_fa' and meth_type = 'INSTANCE' and index_of = 0;
alter class foo04 add method m_fc(int, float, char(10), numeric(10,2));
alter class foo04 add method m_long_arg(int, int, int, int, int, int, int, int, int, int);
alter class foo04 add method m_dummy_file(int) function dummy_file file 'dummy_file_path.o';
select meth_name, meth_type, index_of, data_type 
from db_meth_arg 
where class_name = 'foo04' order by meth_name, meth_type, index_of; 
select * 
from db_meth_file 
where class_name = 'foo04' 
order by path_name, from_class_name;
alter class foo04 rename m_dummy_file as m_dummy_file_new;
alter class foo04 rename function of m_dummy_file_new as dummy_file_new;
alter class foo04 rename file 'dummy_file_path.o' as 'dummy_file_path_new.o';
select func_name 
from db_method 
where class_name = 'foo04' and meth_name = 'm_dummy_file_new' 
order by func_name;
select path_name 
from db_meth_file 
where class_name = 'foo04' 
order by path_name;
create class sub_foo04 under foo04;
select meth_name, func_name, from_class_name, from_meth_name 
from db_method 
where class_name = 'sub_foo04' 
order  by meth_name, func_name, from_class_name, from_meth_name;
select path_name, from_class_name 
from db_meth_file 
where class_name = 'sub_foo04' 
order by path_name, from_class_name;
create class bar04 method m_fa(int), m_fb(int), m_fc(int), m_fd(int), m_fe(int);
alter class bar04 drop method m_fa, m_fc, m_fe;
select meth_name 
from db_method 
where class_name = 'bar04' 
order by meth_name;
alter class bar04 drop method m_fb, m_fd;
select meth_name 
from db_method 
where class_name = 'bar04' 
order by meth_name;
alter class bar04 add method m_ff(int);
alter class bar04 add method class m_ff(int);
select meth_name, meth_type 
from db_method 
where class_name = 'bar04' 
order by meth_name, meth_type;
drop class foo04;
drop class sub_foo04;
drop class bar04;
call login('dba', '') on class db_user;
rollback;
