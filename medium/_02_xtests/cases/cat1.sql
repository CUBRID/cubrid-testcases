autocommit off;
call login('dba', '') on class db_user;
select * from db_class where is_system_class = 'YES' order by class_name;
create class foo01;
create class bar01 (ba int, bb int, bc int, bd int);
select * 
from db_class 
where class_name = 'foo01' or class_name = 'bar01' 
order by class_name;
select attr_name, attr_type 
from db_attribute 
where class_name = 'bar01' 
order by attr_name, attr_type;
alter class bar01 add attribute be foo01 shared NULL, unique (ba);
alter class bar01 add class attribute ba int, bb char(10);
select attr_name, attr_type 
from db_attribute 
where class_name = 'bar01' 
order by attr_name, attr_type;
select * 
from db_index 
where class_name = 'bar01' 
order by index_name, class_name;
alter class bar01 add method m_ba(int) bar01, m_bb(float);
alter class bar01 add method class m_ba(int) bar01;
select meth_name, meth_type 
from db_method 
where class_name = 'bar01' 
order by meth_name, meth_type;
alter class bar01 add file 'here/func.o';
select path_name, from_class_name 
from db_meth_file 
where class_name = 'bar01' 
order by path_name, from_class_name;
create vclass bar01_v;
alter vclass bar01_v add attribute va int;
alter vclass bar01_v add query select ba from bar01;
select vclass_def 
from db_vclass 
where vclass_name = 'bar01_v' 
order by vclass_def;
alter class bar01 add superclass foo01;
select super_class_name 
from db_direct_super_class 
where class_name = 'bar01' 
order by super_class_name;
alter class bar01 change method m_ba(char(10));
select * 
from db_meth_arg 
where class_name = 'bar01' 
order by meth_name, class_name, meth_type, index_of;
alter class bar01 change file 'here/func.o' as 'there/func.o';
select path_name, from_class_name 
from db_meth_file 
where class_name = 'bar01' 
order by path_name, from_class_name;
alter vclass bar01_v change query select bb from bar01;
select vclass_def 
from db_vclass 
where vclass_name = 'bar01_v' 
order by vclass_def;
alter class bar01 drop attribute ba, be;
select attr_name, attr_type 
from db_attribute 
where class_name = 'bar01' 
order by attr_name, attr_type;
select * 
from db_index 
where class_name = 'bar01' 
order by index_name;
alter class bar01 drop method m_ba;
select meth_name, meth_type 
from db_method 
where class_name = 'bar01' 
order by meth_name, meth_type;
alter class bar01 drop file 'there/func.o';
select path_name, from_class_name 
from db_meth_file 
where class_name = 'bar01' 
order by path_name, from_class_name;
alter vclass bar01_v drop query;
select vclass_def 
from db_vclass 
where vclass_name = 'bar01_v' 
order by vclass_def;
alter class bar01 drop superclass foo01;
select super_class_name 
from db_direct_super_class 
where class_name = 'bar01' 
order by class_name;
drop vclass bar01_v;
drop class foo01;
drop class bar01;
rollback work;
rollback;
