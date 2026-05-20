/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 7: After dropping a grantee user (u2) and recreating it with
 * the same name, the previously granted authorization should be gone.
 * db_auth must not show stale entries for the recreated u2.
 */

--+ server-message on

create user u1;
create user u2;

call login('u1','') on class db_user;
create table t1 (col1 int);
GRANT SELECT ON u1.t1 TO u2;

evaluate('7-1. login as u2 (before drop): SELECT on u1.t1 visible');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

call login('dba','') on class db_user;
drop user u2;
create user u2;

evaluate('7-2. login as u2 (after drop and recreate): no inherited authorization');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('7-3. login as u1 (owner): no stale grant on u1.t1 for the dropped u2');
call login('u1','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('7-4. login as dba: catalog state matches above (reference)');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

drop table u1.t1;
drop user u1;
drop user u2;

--+ server-message off
