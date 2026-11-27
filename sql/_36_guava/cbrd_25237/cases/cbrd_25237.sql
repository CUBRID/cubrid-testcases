/**
 *  This test case verifies CBRD-25237: Define the authorization system classes with the system class definition API
 *
 *  The fix moves the definitions of db_root, _db_user, _db_password and _db_authorization from au_install () to the
 *  system class definition API. The cases read the catalog views and check that each part of the definitions stays
 *  as au_install () made it before.
 *
 *  Coverage:
 *    Case 1:  the four classes are system classes of type CLASS owned by DBA
 *    Case 2:  the columns keep their types, precisions, domains and definition order
 *    Case 3:  the groups and direct_groups set columns of _db_user keep the domain _db_user
 *    Case 4:  the class and instance methods keep their implementing functions
 *    Case 5:  the method arguments keep their types, with index 0 as the return value
 *    Case 6:  _db_user keeps the unique index on name
 *    Case 7:  DBA keeps the grants to PUBLIC and INFORMATION_SCHEMA on the classes
 *    Case 8:  the built-in users DBA, PUBLIC and INFORMATION_SCHEMA are rows of _db_user
 */

evaluate 'Case 1: the four classes are system classes of type CLASS owned by DBA';
select class_name, owner_name, class_type, is_system_class, partitioned, is_reuse_oid_class
from db_class
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name;

evaluate 'Case 2: the columns keep their types, precisions, domains and definition order';
select class_name, attr_name, attr_type, def_order, data_type, prec, scale, domain_class_name, default_value, is_nullable
from db_attribute
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, attr_type, def_order;

evaluate 'Case 3: the groups and direct_groups set columns of _db_user keep the domain _db_user';
select class_name, attr_name, attr_type, data_type, prec, scale, domain_class_name
from db_attr_setdomain_elm
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, attr_name, data_type;

evaluate 'Case 4: the class and instance methods keep their implementing functions';
select class_name, meth_name, meth_type, from_class_name, from_meth_name, func_name
from db_method
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, meth_type, meth_name;

evaluate 'Case 5: the method arguments keep their types, with index 0 as the return value';
select class_name, meth_name, meth_type, index_of, data_type, prec, scale, domain_class_name
from db_meth_arg
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, meth_type, meth_name, index_of;

evaluate 'Case 6: _db_user keeps the unique index on name';
select i.class_name, i.index_name, i.is_unique, i.is_reverse, i.is_primary_key, i.is_foreign_key, i.key_count, k.key_attr_name, k.key_order
from db_index i, db_index_key k
where i.class_name = k.class_name and i.index_name = k.index_name
  and i.class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by i.class_name, i.index_name, k.key_order;

evaluate 'Case 7: DBA keeps the grants to PUBLIC and INFORMATION_SCHEMA on the classes';
select grantor_name, grantee_name, object_type, object_name, auth_type, is_grantable
from db_auth
where object_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by object_name, grantee_name, auth_type;

evaluate 'Case 8: the built-in users DBA, PUBLIC and INFORMATION_SCHEMA are rows of _db_user';
select name from db_user where name in ('DBA', 'PUBLIC', 'INFORMATION_SCHEMA') order by name;
