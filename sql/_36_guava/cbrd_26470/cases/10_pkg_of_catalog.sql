/**
 *  This test case verifies CBRD-26470: the package item catalogs refer to their package by an
 *  object reference.
 *
 *  In _db_package_var, _db_package_exception, _db_package_cursor and _db_package_record_type the
 *  string column pkg_unique_name was replaced with pkg_of, a reference to the _db_package row,
 *  and the key became PK (pkg_of, name). While package variable / exception / cursor
 *  declarations are rejected, only the schema of these catalogs is checked.
 *
 *  Coverage (for each of the four catalogs, ordered by class name):
 *    Case 1: pkg_of exists with type OBJECT (expect 1)
 *    Case 2: pkg_unique_name is gone (expect 0)
 *    Case 3: a two-column primary key (expect 1) and no other index (expect 0)
 */

--+ server-message on

evaluate 'Case 1: pkg_of exists with type OBJECT, expect 1 for each catalog';
select c.class_name, (select count(*) from db_attribute a where a.class_name = c.class_name and a.attr_name = 'pkg_of' and a.data_type = 'OBJECT') as pkg_of_object
from db_class c
where c.class_name in ('_db_package_var', '_db_package_exception', '_db_package_cursor', '_db_package_record_type')
order by c.class_name;


evaluate 'Case 2: pkg_unique_name is gone, expect 0 for each catalog';
select c.class_name, (select count(*) from db_attribute a where a.class_name = c.class_name and a.attr_name = 'pkg_unique_name') as pkg_unique_name
from db_class c
where c.class_name in ('_db_package_var', '_db_package_exception', '_db_package_cursor', '_db_package_record_type')
order by c.class_name;


evaluate 'Case 3: PK (pkg_of, name) and no other index, expect 1 and 0 for each catalog';
select c.class_name,
       (select count(*) from db_index i where i.class_name = c.class_name and i.is_primary_key = 'YES' and i.key_count = 2) as pk_two_cols,
       (select count(*) from db_index i where i.class_name = c.class_name and i.is_primary_key = 'NO') as other_index
from db_class c
where c.class_name in ('_db_package_var', '_db_package_exception', '_db_package_cursor', '_db_package_record_type')
order by c.class_name;
select class_name, key_attr_name, key_order from db_index_key
where class_name in ('_db_package_var', '_db_package_exception', '_db_package_cursor', '_db_package_record_type')
order by class_name, key_order;

--+ server-message off
