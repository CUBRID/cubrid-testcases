/**
 * This test case verifies CBRD-25471: db_user.name / owner-name columns unified to varchar(32)
 *
 * Coverage:
 * 1-2 - base table _db_user.name and db_user view name are varchar(32) (set-element size in 8)
 * 3-6 - the 20 remaining dependent owner-name/grantor/grantee views are varchar(32)
 * 7   - aggregate cross-check of every owner-name column's declared size in one query
 * 8   - set-element size of db_user.direct_groups / groups
 * 9   - db_server / _db_server.user_name is intentionally left at varchar(255)
 * 10  - a 31-char user name round-trips through db_user.name
 * 11-12 - a 31-char owner name round-trips through the dependent views' data (not just
 *         declared metadata), including after an OWNER TO transfer
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

/* the 32-char rejection boundary is already covered by bug_bts_6633.sql (sql/_13_issues/_12_1h/cases) -
   only the 31-char accept side is repeated here, as a fixture for Cases 11-12 below */
evaluate 'Case 10: a 31-char user name is accepted and round-trips through db_user.name';
create user cbrd_25471_ok_31_chars_long_xxx;
SELECT name, CHAR_LENGTH(name) FROM db_user WHERE name = 'CBRD_25471_OK_31_CHARS_LONG_XXX' ORDER BY 1;
DROP USER cbrd_25471_ok_31_chars_long_xxx;

evaluate 'Case 11: a 31-char owner name round-trips untruncated through the dependent views';
create user u_______10u_______20u_______30u;
call login ('u_______10u_______20u_______30u', '') on class db_user;

drop table if exists cbrd_25471_t;
create table cbrd_25471_t (c1 int auto_increment primary key, c2 int);
create index i_cbrd_25471_c2 on cbrd_25471_t (c2);
drop view if exists cbrd_25471_v;
create view cbrd_25471_v as select c1 from cbrd_25471_t;
drop synonym if exists cbrd_25471_syn;
create synonym cbrd_25471_syn for cbrd_25471_t;
create trigger cbrd_25471_trg before insert on cbrd_25471_t execute print 'x';
grant select on cbrd_25471_t to public;

/* db_serial has no discoverable row for an inline `auto_increment primary key` column in this
   build (unlike a bare `auto_increment` column, per sql/_01_object/_02_class/_003_auto_increment/
   cases/cubrid60.sql) -- its declared column size is still checked at the metadata level in Case 7 */
select 'db_class' as view_name, owner_name as owner, char_length(owner_name) as len from db_class where class_name = 'cbrd_25471_t'
union all select 'db_vclass', owner_name, char_length(owner_name) from db_vclass where vclass_name = 'cbrd_25471_v'
union all select 'db_attribute', owner_name, char_length(owner_name) from db_attribute where class_name = 'cbrd_25471_t' and attr_name = 'c1'
union all select 'db_index', owner_name, char_length(owner_name) from db_index where class_name = 'cbrd_25471_t' and index_name = 'i_cbrd_25471_c2'
union all select 'db_index_key', owner_name, char_length(owner_name) from db_index_key where class_name = 'cbrd_25471_t' and index_name = 'i_cbrd_25471_c2'
union all select 'db_trigger', owner_name, char_length(owner_name) from db_trigger where trigger_name = 'cbrd_25471_trg'
union all select 'db_synonym', synonym_owner_name, char_length(synonym_owner_name) from db_synonym where synonym_name = 'cbrd_25471_syn'
union all select 'db_auth', grantor_name, char_length(grantor_name) from db_auth where object_name = 'cbrd_25471_t' and grantee_name = 'PUBLIC'
order by 1;

call login ('dba', '') on class db_user;

evaluate 'Case 12: ALTER TABLE ... OWNER TO refreshes owner_name to the full 31-char name';
drop table if exists cbrd_25471_t2;
create table cbrd_25471_t2 (c1 int);
select owner_name, char_length(owner_name) from db_class where class_name = 'cbrd_25471_t2';
alter table cbrd_25471_t2 owner to u_______10u_______20u_______30u;
select owner_name, char_length(owner_name) from db_class where class_name = 'cbrd_25471_t2';

drop table u_______10u_______20u_______30u.cbrd_25471_t2;
drop synonym u_______10u_______20u_______30u.cbrd_25471_syn;
drop view u_______10u_______20u_______30u.cbrd_25471_v;
drop table u_______10u_______20u_______30u.cbrd_25471_t;
drop user u_______10u_______20u_______30u;
