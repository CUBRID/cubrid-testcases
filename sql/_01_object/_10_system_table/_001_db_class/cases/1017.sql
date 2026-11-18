/**
 *  This test case verifies that db_class lists the classes owned by dba.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  db_class lists the classes owned by DBA, except the dml tables of other TCs
 */
--+ holdcas on;
drop table if exists ordby_nulls;
call login('dba') on class db_user;
evaluate 'Case 1: db_class lists the classes owned by DBA, except the dml tables of other TCs';
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  owner_name = 'DBA' and class_name not like 'dml%' order by 1;

--+ holdcas off;
