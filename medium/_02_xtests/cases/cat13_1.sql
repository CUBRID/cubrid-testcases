autocommit off;
call login('dba') on class db_user;
call add_user('USER13_1') on class _db_user;
call add_user('USER13_2') on class _db_user;
create class foo13(da int, db int, dc int);
commit;
call login('USER13_1') on class db_user;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment
from db_class 
where class_name = 'foo13' 
order by class_name;
call login('dba') on class db_user;
grant select on foo13 to USER13_1;
select _db_user to u1 
from _db_user 
where name = 'USER13_1';
select _db_user to u2 
from _db_user 
where name = 'USER13_2';
call add_member(u2) on u1;
commit;
call login('USER13_1') on class db_user;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment
from db_class 
where class_name = 'foo13' 
order by class_name;
call login('USER13_2') on class db_user;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment
from db_class 
where class_name = 'foo13' 
order by class_name;
call login('dba') on class db_user;
drop class foo13;
commit;
call login('dba', '') on class db_user;
rollback;
drop user USER13_1;
drop user USER13_2;
commit;
