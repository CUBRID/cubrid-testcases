/**
 *  This test case verifies that change_owner cannot change the owner of the system class db_class,
 *  so a new user still sees db_class as an ordinary user.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  change_owner of db_class to test_user fails
 *    Case 2:  test_user sees in db_class only the classes it is granted, not the _db_ tables
 *    Case 3:  change_owner of db_class back to dba fails too
 *    Case 4:  dba sees every class in db_class
 */
--+ holdcas on;
call login('dba') on class db_user;
call add_user('test_user') on class _db_user;


evaluate 'Case 1: change_owner of db_class to test_user fails; result = Error:-1145';
call change_owner('db_class', 'test_user') on class db_root;
call login('test_user') on class db_user;
evaluate 'Case 2: test_user sees in db_class only the classes it is granted, not the _db_ tables';
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1;
call login('dba') on class db_user;
evaluate 'Case 3: change_owner of db_class back to dba fails too; result = Error:-1145';
call change_owner('db_class', 'dba') on class db_root;
evaluate 'Case 4: dba sees every class in db_class';
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1;

call drop_user('test_user') on class _db_user;


--+ holdcas off;
