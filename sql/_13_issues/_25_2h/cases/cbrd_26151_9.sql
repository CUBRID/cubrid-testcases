/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 9 (VIEW): u1 owns a view and grants SELECT to u2 and UPDATE to u3.
 * Each user sees only the authorizations where it is grantor or grantee
 * (object_type VCLASS); DBA sees all.
 */

--+ server-message on

create user u1;
create user u2;
create user u3;

call login('u1','') on class db_user;
create table base_tbl (col1 int);
create view v1 as select * from u1.base_tbl;
GRANT SELECT ON u1.v1 TO U2;
GRANT UPDATE ON u1.v1 TO U3;

evaluate('9-1. login as u1: only authorizations where u1 is grantor');
call login('u1','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('9-2. login as u2: only the SELECT authorization where u2 is grantee');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('9-3. login as u3: only the UPDATE authorization where u3 is grantee');
call login('u3','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('9-4. login as dba: all authorizations are visible');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

drop view u1.v1;
drop table u1.base_tbl;
drop user u1;
drop user u2;
drop user u3;

--+ server-message off
