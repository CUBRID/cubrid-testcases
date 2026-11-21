/**
 *  This test case verifies CBRD-25237 : Define the authorization system classes with the system class definition API
 *  The definitions of db_root, _db_user, _db_password and _db_authorization (columns, set domains, methods,
 *  method arguments, the unique index, the owner and the grants) must stay as au_install () made them before.
 */

evaluate '1. classes: owner, system class, type';
select class_name, owner_name, class_type, is_system_class, partitioned, is_reuse_oid_class
from db_class
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name;

evaluate '2. columns in definition order';
select class_name, attr_name, attr_type, def_order, data_type, prec, scale, domain_class_name, default_value, is_nullable
from db_attribute
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, attr_type, def_order;

evaluate '3. set domains';
select class_name, attr_name, attr_type, data_type, prec, scale, domain_class_name
from db_attr_setdomain_elm
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, attr_name, data_type;

evaluate '4. methods and their functions';
select class_name, meth_name, meth_type, from_class_name, from_meth_name, func_name
from db_method
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, meth_type, meth_name;

evaluate '5. method signatures (index 0 = return value)';
select class_name, meth_name, meth_type, index_of, data_type, prec, scale, domain_class_name
from db_meth_arg
where class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by class_name, meth_type, meth_name, index_of;

evaluate '6. indexes';
select i.class_name, i.index_name, i.is_unique, i.is_reverse, i.is_primary_key, i.is_foreign_key, i.key_count, k.key_attr_name, k.key_order
from db_index i, db_index_key k
where i.class_name = k.class_name and i.index_name = k.index_name
  and i.class_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by i.class_name, i.index_name, k.key_order;

evaluate '7. grants';
select grantor_name, grantee_name, object_type, object_name, auth_type, is_grantable
from db_auth
where object_name in ('db_root', '_db_user', '_db_password', '_db_authorization')
order by object_name, grantee_name, auth_type;

evaluate '8. the built-in users are rows of _db_user';
select name from db_user where name in ('DBA', 'PUBLIC', 'INFORMATION_SCHEMA') order by name;
