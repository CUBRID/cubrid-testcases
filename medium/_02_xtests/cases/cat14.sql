autocommit off;
call login('dba') on class db_user;
create class foo14 method foo14_fn(set(int), float) set(object, char(5));
select * 
from db_meth_arg_setdomain_elm 
where class_name = 'foo14' and meth_name = 'foo14_fn' order by 1,2,3,4,5;
alter class foo14 add file 'here/test';
create class s1foo14 under foo14;
create class s2foo14 under s1foo14;
alter class s1foo14 add file 'there/test';
select * 
from db_meth_file 
where class_name = 's2foo14' order by 1,2,3;
create class s3foo14 under s2foo14;
select * 
from db_meth_file 
where class_name = 's3foo14' order by 1,2,3;
drop class s3foo14;
drop class s2foo14;
drop class s1foo14;
drop class foo14;
call login('dba', '') on class db_user;
rollback;
