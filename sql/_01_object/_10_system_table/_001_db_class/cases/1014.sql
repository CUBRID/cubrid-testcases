/**
 *  This test case verifies that dba can list all system classes from db_class.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  db_class lists every system class and view for dba
 */
--+ holdcas on;
call login('dba') on class db_user;
evaluate 'Case 1: db_class lists every system class and view for dba';
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  is_system_class = 'YES' order by 1,2;
--+ holdcas off;
