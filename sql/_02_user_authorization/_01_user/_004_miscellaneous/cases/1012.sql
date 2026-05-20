--+ holdcas on;
--[er]Test change_owner() methods to change system table,then new user cannot access the system table
call login('dba') on class db_user;
call add_user('test_user') on class _db_user;


call change_owner('db_class', 'test_user') on class db_root;
call login('test_user') on class db_user;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1;
call login('dba') on class db_user;
call change_owner('db_class', 'dba') on class db_root;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1;

call drop_user('test_user') on class _db_user;


--+ holdcas off;
