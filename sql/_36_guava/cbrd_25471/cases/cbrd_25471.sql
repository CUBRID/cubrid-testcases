/**
 * This test case verifies CBRD-25471: db_user.name / owner-name columns unified to varchar(32)
 *
 * Coverage:
 * 1-2 - base table _db_user.name and db_user view columns are varchar(32)
 * 3-6 - the 19 remaining dependent owner-name/grantor/grantee views are varchar(32)
 * 7   - aggregate cross-check of every owner-name column's declared size in one query
 * 8   - set-element size of db_user.direct_groups / groups
 * 9   - db_server / _db_server.user_name is intentionally left at varchar(255)
 * 10  - a 32-char user name round-trips through db_user.name without truncation
 */

evaluate 'Case 1: base table _db_user.name is varchar(32)';
desc _db_user;

evaluate 'Case 2: db_user view (name, direct_groups, groups) is varchar(32)';
show create view db_user;

evaluate 'Case 3: class-object owner-name views are varchar(32)';
show create view db_class;
show create view db_direct_super_class;
show create view db_vclass;
show create view db_attribute;
show create view db_attr_setdomain_elm;

evaluate 'Case 4: method-related owner-name views are varchar(32)';
show create view db_method;
show create view db_meth_arg;
show create view db_meth_arg_setdomain_elm;
show create view db_meth_file;

evaluate 'Case 5: index / auth / trigger / partition owner-name views are varchar(32)';
show create view db_index;
show create view db_index_key;
show create view db_auth;
show create view db_trigger;
show create view db_partition;

evaluate 'Case 6: stored procedure / serial / authorization / synonym / server owner-name views are varchar(32)';
show create view db_stored_procedure;
show create view db_stored_procedure_args;
show create view db_serial;
show create view db_authorization;
show create view db_synonym;
show create view db_server;

evaluate 'Case 7: aggregate check - every owner-name column across all dependent views is varchar(32)';
SELECT class_name, attr_name, data_type, prec
FROM db_attribute
WHERE class_name IN (
        'db_class', 'db_direct_super_class', 'db_vclass', 'db_attribute',
        'db_attr_setdomain_elm', 'db_method', 'db_meth_arg',
        'db_meth_arg_setdomain_elm', 'db_meth_file', 'db_index', 'db_index_key',
        'db_auth', 'db_trigger', 'db_partition', 'db_stored_procedure',
        'db_stored_procedure_args', 'db_serial', 'db_authorization',
        'db_synonym', 'db_server', 'db_user'
      )
  AND attr_name IN (
        'owner', 'owner_name', 'super_owner_name', 'from_owner_name',
        'domain_owner_name', 'target_owner_name', 'synonym_owner_name',
        'grantor_name', 'grantee_name', 'referential_index_class_owner_name',
        'name'
      )
ORDER BY class_name, attr_name;

evaluate 'Case 8: db_user.direct_groups / groups set-element size is varchar(32)';
SELECT class_name, attr_name, data_type, prec
FROM db_attr_setdomain_elm
WHERE class_name = 'db_user' AND attr_name IN ('direct_groups', 'groups')
ORDER BY attr_name;

evaluate 'Case 9: db_server / _db_server.user_name is NOT changed, stays varchar(255)';
SELECT class_name, attr_name, data_type, prec
FROM db_attribute
WHERE class_name IN ('_db_server', 'db_server') AND attr_name = 'user_name'
ORDER BY class_name;

drop user if exists cbrd_25471_user_32_chars_long_ok;

evaluate 'Case 10: a 32-char user name round-trips through db_user.name without truncation';
create user cbrd_25471_user_32_chars_long_ok;
SELECT name, CHAR_LENGTH(name) FROM db_user WHERE name = 'cbrd_25471_user_32_chars_long_ok';

drop user if exists cbrd_25471_user_32_chars_long_ok;
