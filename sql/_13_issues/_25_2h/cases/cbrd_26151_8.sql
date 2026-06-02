/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 8: After renaming a table (u1.t1 -> u1.alter_t1), the existing
 * grant must follow the table. db_auth must show the SELECT grant against
 * the new object_name 'alter_t1' for the grantee u2.
 */

--+ server-message on

create user u1;
create user u2;

call login('u1','') on class db_user;
create table t1 (col1 int);
GRANT SELECT ON u1.t1 TO u2;

evaluate('8-1. login as u2 (before rename): SELECT on u1.t1 visible');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

call login('u1','') on class db_user;
RENAME TABLE u1.t1 AS u1.alter_t1;

evaluate('8-2. login as u2 (after rename): SELECT now reported on alter_t1');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

evaluate('8-3. login as u1 (owner): grant follows the renamed table');
call login('u1','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

evaluate('8-4. login as dba: catalog state matches above (reference)');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

drop table u1.alter_t1;
drop user u1;
drop user u2;

--+ server-message off
