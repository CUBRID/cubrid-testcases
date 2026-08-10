/**
 * This test case verifies CBRD-25471: db_user.name / owner-name columns unified to varchar(32)
 *
 * Coverage:
 * 1-2 - base table _db_user.name and db_user view name are varchar(32) (set-element size in 8)
 * 3-6 - the 20 remaining dependent owner-name/grantor/grantee views are varchar(32)
 * 7   - aggregate cross-check of every owner-name column's declared size in one query
 * 8   - set-element size of db_user.direct_groups / groups
 * 9   - db_server / _db_server.user_name is intentionally left at varchar(255)
 * 10  - a 31-char user name round-trips through db_user.name; a 32-char name is rejected
 */

evaluate 'Case 1: base table _db_user.name is varchar(32)';
desc _db_user;

evaluate 'Case 2: db_user view name is varchar(32) (direct_groups/groups element size checked in Case 8)';
desc db_user;

evaluate 'Case 3: class-object owner-name views are varchar(32)';
desc db_class;
desc db_direct_super_class;
desc db_vclass;
desc db_attribute;
desc db_attr_setdomain_elm;

evaluate 'Case 4: method-related owner-name views are varchar(32)';
desc db_method;
desc db_meth_arg;
desc db_meth_arg_setdomain_elm;
desc db_meth_file;

evaluate 'Case 5: index / auth / trigger / partition owner-name views are varchar(32)';
desc db_index;
desc db_index_key;
desc db_auth;
desc db_trigger;
desc db_partition;

evaluate 'Case 6: stored procedure / serial / authorization / synonym / server owner-name views are varchar(32)';
desc db_stored_procedure;
desc db_stored_procedure_args;
desc db_serial;
desc db_authorization;
desc db_synonym;
desc db_server;

evaluate 'Case 7: aggregate check - every owner-name column across all dependent views is varchar(32)';
SELECT class_name, attr_name, data_type, prec
FROM db_attribute
WHERE class_name IN (
        'db_class', 'db_direct_super_class', 'db_vclass', 'db_attribute',
        'db_attr_setdomain_elm', 'db_method', 'db_meth_arg',
        'db_meth_arg_setdomain_elm', 'db_meth_file', 'db_index', 'db_index_key',
        'db_auth', 'db_trigger', 'db_partition', 'db_stored_procedure',
        'db_stored_procedure_args', 'db_serial', 'db_authorization',
        'db_synonym', 'db_server'
      )
  AND attr_name IN (
        'owner', 'owner_name', 'super_owner_name', 'from_owner_name',
        'domain_owner_name', 'target_owner_name', 'synonym_owner_name',
        'grantor_name', 'grantee_name', 'referential_index_class_owner_name'
      )
ORDER BY class_name, attr_name;

evaluate 'Case 8: db_user.direct_groups / groups set-element size is varchar(32)';
SELECT class_name, attr_name, data_type, prec
FROM db_attr_setdomain_elm
WHERE class_name = 'db_user' AND attr_name IN ('direct_groups', 'groups')
ORDER BY attr_name, data_type, prec;

evaluate 'Case 9: db_server / _db_server.user_name is NOT changed, stays varchar(255)';
SELECT class_name, attr_name, data_type, prec
FROM db_attribute
WHERE class_name IN ('_db_server', 'db_server') AND attr_name = 'user_name'
ORDER BY class_name;

evaluate 'Case 10a: a 31-char user name is accepted and round-trips through db_user.name';
create user cbrd_25471_ok_31_chars_long_xxx;
SELECT name, CHAR_LENGTH(name) FROM db_user WHERE name = 'CBRD_25471_OK_31_CHARS_LONG_XXX' ORDER BY 1;
DROP USER cbrd_25471_ok_31_chars_long_xxx;

evaluate 'Case 10b: a 32-char user name is rejected (DB_MAX_USER_LENGTH boundary)';
/* err */ create user cbrd_25471_too_long_32_chars_xxx;
