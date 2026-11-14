/**
 *  This test case verifies that dba can retrieve all columns of db_class (old bug xdbm808, no Jira key).
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  db_class returns every column of every class for dba
 */
--+ holdcas on;
drop table if exists ordby_nulls;
call login ('dba') on class db_user;
evaluate 'Case 1: db_class returns every column of every class for dba';
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1,2,3,4,5,6;

--+ holdcas off;
