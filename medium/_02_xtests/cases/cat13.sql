autocommit off;
call login('dba') on class db_user;
call add_user('USER13_1') on class db_user;
call add_user('USER13_2') on class db_user;
create class foo13(da int, db int, dc int);
call login('USER13_1') on class db_user;
select * 
from db_class 
where class_name = 'foo13' 
order by class_name;
call login('dba') on class db_user;
grant select on foo13 to USER13_1;
select db_user to u1 
from db_user 
where name = 'USER13_1';
select db_user to u2 
from db_user 
where name = 'USER13_2';
call add_member(u2) on u1;
call login('USER13_1') on class db_user;
select * 
from db_class 
where class_name = 'foo13' 
order by class_name;
call login('USER13_2') on class db_user;
select * 
from db_class 
where class_name = 'foo13' 
order by class_name;
call login('dba') on class db_user;
drop class foo13;
call login('dba', '') on class db_user;
rollback;
